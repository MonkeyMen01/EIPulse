package com.eipulse.teamproject;

import com.eipulse.teamproject.dto.shoppingdto.CartDTO;
import com.eipulse.teamproject.entity.shoppingentity.Cart;
import com.eipulse.teamproject.repository.EmpRepository;
import com.eipulse.teamproject.repository.shoppingrepository.CartRepository;
import com.eipulse.teamproject.service.EmpService;
import com.eipulse.teamproject.service.shoppingservice.CartService;
import com.eipulse.teamproject.service.shoppingservice.OrderService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.jpa.repository.query.JSqlParserUtils;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@SpringBootTest
class TeamprojectApplicationTests {

	@Autowired
	private OrderService orderService;
	@Autowired
	private CartService cartService;
	@Test
	@Transactional
	void contextLoads() {
		CartDTO cartDTO = cartService.findOrCreateShoppingCartByEmpId(1001);
		orderService.saveOrder(cartDTO);
	}

}
