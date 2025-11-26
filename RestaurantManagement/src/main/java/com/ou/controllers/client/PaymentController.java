/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ou.controllers.client;

import com.ou.utils.TwilioUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.ou.pojos.Bill;
import com.ou.pojos.Order;
import com.ou.services.client.OrderService;
import com.ou.services.client.PaymentService;
import java.math.BigDecimal;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDate;
import java.util.List;
import java.util.concurrent.ExecutionException;
import javax.transaction.Transactional;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import com.ou.utils.MomoUtil;
import com.twilio.Twilio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Danh Nguyen
 */
@Controller
@Transactional
public class PaymentController {

    @Autowired
    private PaymentService paymentService;
    @Autowired
    private OrderService orderService;

    @Autowired
    private MomoUtil momoUtil;

    @Autowired
    private TwilioUtil twilioUtil;

    @GetMapping("/payment")
    public String payment(Model model, @RequestParam(value = "id") String id) {
        List<Object[]> orderInfo = this.paymentService.getOrderInfo(id);
        List<Object[]> menuInfo = this.paymentService.getMenuOrder(id);
        List<Object[]> serInfo = this.paymentService.getServiceOrder(id);
        model.addAttribute("orderInfo", orderInfo);
        model.addAttribute("menuInfo", menuInfo);
        model.addAttribute("serInfo", serInfo);
        return "payment";
    }

    @GetMapping("/payment-cash/created-bill")
    public String paymentCash(@RequestParam(value = "totalMoney") String totalMoney,
            @RequestParam(value = "ordId") int ordId,
            @RequestParam(value = "userId") String userId) {
        Bill bill = new Bill();
        bill.setId(ordId);
        bill.setUserId(Integer.parseInt(userId));
        bill.setBillCreatedDate(LocalDate.now());
        bill.setBillTotalMoney(new BigDecimal(totalMoney));
        if (paymentService.createBill(bill)) {
            Order order = orderService.getOrderById(bill.getId());
            order.setOrdIsPayment(true);
            if (orderService.updateOrderIsPayment(order)) {
                return "redirect:/payment-success";
            }
        }
        return "redirect:/payment-fails";
    }

    @GetMapping("/payment-momo/created-bill")
    public String paymentPost(@RequestParam(value = "totalMoney") String totalMoney,
            @RequestParam(value = "ordId") int ordId,
            @RequestParam(value = "userId") String userId,
            HttpServletRequest request) throws NoSuchAlgorithmException,
            InvalidKeyException, ExecutionException, JsonProcessingException, InterruptedException {
        Bill bill = new Bill();
        bill.setId(ordId);
        bill.setUserId(Integer.parseInt(userId));
        bill.setBillCreatedDate(LocalDate.now());
        bill.setBillTotalMoney(new BigDecimal(totalMoney));
        // Build URL dynamically using request
        String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
        String url = String.format("%s/payment-completed?ordId=%d&userId=%d&totalMoney=%f",
                 baseUrl, bill.getId(), bill.getUserId(), bill.getBillTotalMoney());
        return String.format("redirect:%s", momoUtil.createOrder(bill.getBillTotalMoney().divide(new BigDecimal(1000)),
                "Thanh toan tiec", url, url).get("payUrl"));
    }

    @GetMapping("/payment-success")
    public String paymentSuccess() {
        Twilio.init(twilioUtil.ACCOUNT_SID, twilioUtil.AUTH_TOKEN);
        Message message = Message.creator( new PhoneNumber(twilioUtil.TO_PHONE),
                new PhoneNumber(twilioUtil.FROM_PHONE),
                "Quý khách đã thanh toán thành công...").create();
        System.out.println(message.getSid());
        return "payment-success";
    }

    @GetMapping("/payment-completed")
    public String paymentCompleted(@RequestParam(value = "ordId") int ordId,
            @RequestParam(value = "userId") int userId,
            @RequestParam(value = "totalMoney") BigDecimal totalMoney) {
        orderService.getOrderById(ordId);
        Bill bill = new Bill();
        bill.setId(ordId);
        bill.setUserId(userId);
        bill.setBillCreatedDate(LocalDate.now());
        bill.setBillTotalMoney(totalMoney);
        if (paymentService.createBill(bill)) {
            Order order = orderService.getOrderById(bill.getId());
            order.setOrdIsPayment(true);
            if (orderService.updateOrderIsPayment(order)) {
                return "redirect:/payment-success";
            }
        }
        return "payment-completed";
    }

}
