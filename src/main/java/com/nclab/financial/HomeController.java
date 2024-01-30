package com.nclab.financial;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Handles requests for the application home page.
 */

@Controller
@RequestMapping("/")
public class HomeController {
	
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping("empList")
	public String home(Model model) {
		System.out.println("controller_empList");
		return "empList";
	}
	
	@RequestMapping("onLoad")
	public String onLoad() {
		return "onLoad";
	}
	
	@RequestMapping("save")
	public String save(Model model) {
		
		return "save";
	}
	
	@RequestMapping("delete")
	public String delete(Model model) {
		
		return "delete";
	}
	
	@RequestMapping("load")
	public String load() {
		return "code/load";
	}
	
	@RequestMapping("detail")
	public String detail() {
		return "code/detail";
	}
	
	@RequestMapping("saveAll")
	public String saveAll() {
		return "code/saveAll";
	}
	
	@RequestMapping("excelSave")
	public String excelSave() {
		return "excelSave";
	}
}
