package com.flow.fileBlock.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class extensionVO {
	private int id;
	private String name;
	private String type;
	private boolean status;

	private extensionVO() {
	}
}
