package com.flow.fileBlock.controller;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.flow.fileBlock.domain.extensionVO;
import com.flow.fileBlock.service.ExtensionService;

@RestController
public class ExtensionController {

	@Inject
	ExtensionService extensionService;

	@RequestMapping("/")
	public ModelAndView typeChoice() {
		ModelAndView mav = new ModelAndView();

		Map<String, List<extensionVO>> extensionMap = extensionService.listExtension();

		mav.addObject("extensionMap", extensionMap);
		mav.setViewName("main");

		return mav;
	}

	@RequestMapping({ "/insertExtension" })
	public int insertExtension(extensionVO extensionVO) {
		int id = extensionService.insertExtension(extensionVO);
		return id;
	}

	@RequestMapping({ "/extensionCheck" })
	public boolean extensionCheck(String fileExtension) {
		return extensionService.extensionCheck(fileExtension);
	}

	@RequestMapping({ "/updateExtension" })
	public void updateExtension(extensionVO extensionVO) {
		extensionService.updateExtension(extensionVO);
	}

	@RequestMapping({ "/deleteExtension" })
	public void deleteExtension(int id) {
		extensionService.deleteExtension(id);
	}
}
