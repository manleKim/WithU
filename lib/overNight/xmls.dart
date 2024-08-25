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
