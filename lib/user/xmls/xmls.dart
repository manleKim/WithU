String getInOutXml(String dormitoryNumber) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
	<Parameters />
	<Dataset id="dsInout">
		<ColumnInfo>
			<Column id="SCHAFS_NO" type="STRING" size="256" />
			<Column id="BRHS_CODE" type="STRING" size="256" />
		</ColumnInfo>
		<Rows>
			<Row>
				<Col id="SCHAFS_NO">$dormitoryNumber</Col>
				<Col id="BRHS_CODE">SS</Col>
			</Row>
		</Rows>
	</Dataset>
</Root>''';
}

String getUserAndRewordXml(String dormitoryNumber) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
	<Parameters />
	<Dataset id="dsSearch">
		<ColumnInfo>
			<Column id="LOGIN_ID" type="STRING" size="256" />
			<Column id="SEMSTR_SE_CD" type="STRING" size="256" />
			<Column id="BRHS_CODE" type="STRING" size="256" />
		</ColumnInfo>
		<Rows>
			<Row>
				<Col id="LOGIN_ID">$dormitoryNumber</Col>
				<Col id="SEMSTR_SE_CD">0</Col> // 학기
				<Col id="BRHS_CODE">SS</Col>
			</Row>
		</Rows>
	</Dataset>
</Root>''';
}

String getReassessCountXml(String dormitoryNumber, int year) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
	<Parameters />
	<Dataset id="dsSearch">
		<ColumnInfo>
			<Column id="LOGIN_ID" type="STRING" size="256" />
			<Column id="SEMSTR_SE_CD" type="STRING" size="256" />
			<Column id="LIFE_YEAR" type="STRING" size="256" />
			<Column id="BRHS_CODE" type="STRING" size="256" />
		</ColumnInfo>
		<Rows>
			<Row>
				<Col id="LOGIN_ID">$dormitoryNumber</Col>
				<Col id="SEMSTR_SE_CD">0</Col>
				<Col id="LIFE_YEAR">$year</Col>
				<Col id="BRHS_CODE">SS</Col>
			</Row>
		</Rows>
	</Dataset>
</Root>''';
}

String getReassessDetailXml(String dormitoryNumber, int year) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
	<Parameters />
	<Dataset id="dsSearch">
		<ColumnInfo>
			<Column id="LOGIN_ID" type="STRING" size="256" />
			<Column id="SEMSTR_SE_CD" type="STRING" size="256" />
			<Column id="LIFE_YEAR" type="STRING" size="256" />
			<Column id="BRHS_CODE" type="STRING" size="256" />
		</ColumnInfo>
		<Rows>
			<Row>
				<Col id="LOGIN_ID">$dormitoryNumber</Col>
				<Col id="SEMSTR_SE_CD">0</Col>
				<Col id="LIFE_YEAR">$year</Col>
				<Col id="BRHS_CODE">SS</Col>
			</Row>
		</Rows>
	</Dataset>
</Root>''';
}

String getScoreDetailXml(String dormitoryNumber) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
	<Parameters />
	<Dataset id="dsSearch">
		<ColumnInfo>
			<Column id="LOGIN_ID" type="STRING" size="256" />
			<Column id="SEMSTR_SE_CD" type="STRING" size="256" />
			<Column id="BRHS_CODE" type="STRING" size="256" />
		</ColumnInfo>
		<Rows>
			<Row>
				<Col id="LOGIN_ID">$dormitoryNumber</Col>
				<Col id="SEMSTR_SE_CD">0</Col>
				<Col id="BRHS_CODE">SS</Col>
			</Row>
		</Rows>
	</Dataset>
</Root>''';
}

String getOverNightDetailXml(String dormitoryNumber) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
	<Parameters />
	<Dataset id="dsInout">
		<ColumnInfo>
			<Column id="SCHAFS_NO" type="STRING" size="256" />
			<Column id="BRHS_CODE" type="STRING" size="256" />
		</ColumnInfo>
		<Rows>
			<Row>
				<Col id="SCHAFS_NO">$dormitoryNumber</Col>
				<Col id="BRHS_CODE">SS</Col>
			</Row>
		</Rows>
	</Dataset>
</Root>''';
}
