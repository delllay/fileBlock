package com.flow.fileBlock.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.flow.fileBlock.domain.extensionVO;
import com.flow.fileBlock.persistence.ExtensionDAO;

@Service
public class ExtensionService {
	@Inject
	ExtensionDAO extensionDAO;

	public Map<String, List<extensionVO>> listExtension() {
		List<extensionVO> extensionList = extensionDAO.selecList();

		Map<String, List<extensionVO>> extensionMap = new HashMap<String, List<extensionVO>>();

		List<extensionVO> fixedExtensionList = new ArrayList<extensionVO>();
		List<extensionVO> customExtensionList = new ArrayList<extensionVO>();

		for (extensionVO extension : extensionList) {
			if (extension.getType().equals("fixed"))
				fixedExtensionList.add(extension);
			else
				customExtensionList.add(extension);
		}

		extensionMap.put("fixedExtensionList", fixedExtensionList);
		extensionMap.put("customExtensionList", customExtensionList);

		return extensionMap;
	}

	public boolean extensionCheck(String name) {
		extensionVO extension = extensionDAO.selectByName(name);

		if (extension == null)
			return false;
		else {
			if (extension.getType().equals("fixed"))
				return extension.isStatus();
			else {
				return true;
			}
		}
	}

	public int insertExtension(extensionVO extensionVO) {
		if (extensionDAO.selectByName(extensionVO.getName()) != null) {
			if (extensionDAO.selectByName(extensionVO.getName()).getType().equals("fixed"))
				return 0;
			else
				return -1;
		} else
			return extensionDAO.insertExtension(extensionVO);
	}

	public void updateExtension(extensionVO extensionVO) {
		extensionDAO.updateExtension(extensionVO);
	}

	public void deleteExtension(int id) {
		extensionDAO.deleteExtension(id);
	}
}
