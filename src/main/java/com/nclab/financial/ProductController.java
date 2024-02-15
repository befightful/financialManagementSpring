package com.nclab.financial;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("product/*")
public class ProductController {
	
	@RequestMapping("Pserch")
	public String Pserch(Model model) {
		System.out.println("serch start");
		return "productSerch";
	}
	
	@RequestMapping("save")
	public String save(Model model) {
		return "save";
	}
	
	@RequestMapping("delete")
	public String delete(Model model) {
		return "delete";
	}
	
	@RequestMapping("Popupsearch")
	public String Popupsearch(Model model) {
		return "popupSearch";
	}
}
