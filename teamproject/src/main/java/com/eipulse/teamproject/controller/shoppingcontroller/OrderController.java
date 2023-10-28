package com.eipulse.teamproject.controller.shoppingcontroller;


import com.eipulse.teamproject.dto.shoppingdto.CartDTO;
import com.eipulse.teamproject.dto.shoppingdto.OrderDTO;
import com.eipulse.teamproject.entity.shoppingentity.Order;
import com.eipulse.teamproject.entity.shoppingentity.OrderItem;
import com.eipulse.teamproject.repository.shoppingrepository.ProductTypeRepository;
import com.eipulse.teamproject.service.shoppingservice.OrderService;
import ecpay.payment.integration.AllInOne;
import ecpay.payment.integration.domain.AioCheckOutOneTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.datetime.DateFormatter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;


@RestController
public class OrderController {
    private OrderService orderService;
    private final ProductTypeRepository productTypeRepository;

    @Autowired
    public OrderController(OrderService orderService,
                           ProductTypeRepository productTypeRepository) {
        this.orderService = orderService;
        this.productTypeRepository = productTypeRepository;
    }

    @PostMapping("/order/ecPlay")
    public ResponseEntity<?> ecPlayOrder(@RequestBody CartDTO cartDTO){
        try{
            return new ResponseEntity<>(orderService.ecPlayForm(cartDTO),HttpStatus.OK);

        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }


    @PostMapping("/ecPlay/success")
    public ResponseEntity<?> PlaySuccess(){
        System.out.println("付款成功");
        try{
            System.out.println("付款成功");
            return new ResponseEntity<>("付款成功",HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            System.out.println("付款失敗");
            return new ResponseEntity<>("付款失敗",HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping("/order/{empId}")
    public ResponseEntity<?> findByEmpOrder(@PathVariable Integer empId){
        try{
            return new ResponseEntity<>(orderService.findOrderByEmp(empId), HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping("/order/details/{empId}")
    public ResponseEntity<?> findByLastOrder(@PathVariable Integer empId){
        try{
            return new ResponseEntity<>(orderService.findByEmpLastOrder(empId), HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/order/item/{orderId}")
    public ResponseEntity<?> findByOrderId(@PathVariable Integer orderId){
        try{
            return new ResponseEntity<>(orderService.findByOrderId(orderId), HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping("/orders")
    public ResponseEntity<?> findAllOrder(){
        try{
            return new ResponseEntity<>(orderService.findAllOrder(), HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
    @PutMapping("/order")
    public ResponseEntity<?> updateStatus(@RequestBody OrderDTO orderDTO){
        try{
            Order order = orderService.findByOrderId(orderDTO.getOrderId());
            order.setStatus(orderDTO.getStatus());
            return new ResponseEntity<>(orderService.updateStatus(order), HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }
}
