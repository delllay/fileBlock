package com.flow.fileBlock.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.flow.fileBlock.domain.extensionVO;

@Repository
public class ExtensionDAO {

	@Inject
	private SqlSession sqlSession;

	public List<extensionVO> selecList() {
		List<extensionVO> extensionList = sqlSession.selectList("ExtensionMapper.listExtension");
		return extensionList;
	}

	public extensionVO selectByName(String name) {
		return sqlSession.selectOne("ExtensionMapper.selectByExtensionName", name);
	}

	public int insertExtension(extensionVO extensionVO) {
		sqlSession.insert("ExtensionMapper.insertExtension", extensionVO);
		return extensionVO.getId();
	}

	public void updateExtension(extensionVO extensionVO) {
		sqlSession.update("ExtensionMapper.updateExtension", extensionVO);
	}

	public void deleteExtension(int id) {
		sqlSession.delete("ExtensionMapper.deleteExtension", id);
	}
}
