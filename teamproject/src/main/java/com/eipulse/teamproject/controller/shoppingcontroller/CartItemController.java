package com.eipulse.teamproject.controller.shoppingcontroller;

import com.eipulse.teamproject.dto.shoppingdto.CartItemDTO;
import com.eipulse.teamproject.service.shoppingservice.CartItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class CartItemController {

    private CartItemService cartItemService;

    @Autowired
    public CartItemController(CartItemService cartItemService) {
        this.cartItemService = cartItemService;
    }

    @PostMapping("/cartItem")
    public ResponseEntity<?> saveCartItem(@RequestBody CartItemDTO cartItemDTO){
        try{
            return new ResponseEntity<>(cartItemService.saveCartItem(cartItemDTO), HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(e.getMessage(),HttpStatus.BAD_REQUEST);
        }
    }
    @PutMapping("/cartItem")
    public ResponseEntity<?> putCartItem(@RequestBody CartItemDTO cartItemDTO){
        try{
            cartItemService.updateCartItem(cartItemDTO);
            return new ResponseEntity<>( HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(e.getMessage(),HttpStatus.BAD_REQUEST);
        }
    }
    @DeleteMapping("/cartItem/{cartItemId}")
    public ResponseEntity<?> deleteCartItem(@PathVariable Integer cartItemId){
        try{
            cartItemService.removeCartItem(cartItemId);
            return new ResponseEntity<>( HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(e.getMessage(),HttpStatus.BAD_REQUEST);
        }
    }
}
