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

String postOverNightXml(
    {required String id,
    required String startDate,
    required String endDate,
    required String reasonType,
    required String reasonDetail,
    required String destinationState,
    required String destinationCity}) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
	<Parameters />
	<Dataset id="dsListSave">
		<ColumnInfo>
			<Column id="IDX" type="STRING" size="256" />
			<Column id="RESCHR_NM" type="STRING" size="256" />
			<Column id="SCHAFS_NO" type="STRING" size="256" />
			<Column id="FLOOR_ROOM_NO" type="STRING" size="256" />
			<Column id="STAYOUT_FR_DT" type="STRING" size="256" />
			<Column id="STAYOUT_TO_DT" type="STRING" size="256" />
			<Column id="STAYOUT_RESN" type="STRING" size="256" />
			<Column id="STAYOUT_RESN2" type="STRING" size="256" />
			<Column id="DSTN_NM" type="STRING" size="256" />
			<Column id="DSTN_NM2" type="STRING" size="256" />
			<Column id="BRHS_CODE" type="STRING" size="256" />
		</ColumnInfo>
		<Rows>
			<Row type="insert">
				<Col id="IDX">$id</Col>
				<Col id="STAYOUT_FR_DT">$startDate</Col>
				<Col id="STAYOUT_TO_DT">$endDate</Col>
				<Col id="STAYOUT_RESN">$reasonType</Col>
				<Col id="STAYOUT_RESN2">$reasonDetail</Col>
				<Col id="DSTN_NM">$destinationState</Col>
				<Col id="DSTN_NM2">$destinationCity</Col>
				<Col id="BRHS_CODE">SS</Col>
			</Row>
		</Rows>
	</Dataset>
</Root>''';
}

String postGoHomeXml(
    {required String id,
    required String startDate,
    required String endDate,
    required String reasonType,
    required String reasonDetail,
    required String destinationState,
    required String destinationCity}) {
  return '''<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
	<Parameters />
	<Dataset id="dsListSave">
		<ColumnInfo>
			<Column id="IDX" type="STRING" size="256" />
			<Column id="RESCHR_NM" type="STRING" size="256" />
			<Column id="SCHAFS_NO" type="STRING" size="256" />
			<Column id="FLOOR_ROOM_NO" type="STRING" size="256" />
			<Column id="HOME_DT" type="STRING" size="256" />
			<Column id="HOME_RTRN_DT" type="STRING" size="256" />
			<Column id="HOME_DSTN" type="STRING" size="256" />
			<Column id="HOME_DSTN2" type="STRING" size="256" />
			<Column id="BRHS_CODE" type="STRING" size="256" />
		</ColumnInfo>
		<Rows>
			<Row type="insert">
				<Col id="IDX">$id</Col>
				<Col id="HOME_DT">$startDate</Col>
				<Col id="HOME_RTRN_DT">$endDate</Col>
				<Col id="HOME_DSTN">$destinationState</Col>
				<Col id="HOME_DSTN2">$destinationCity</Col>
				<Col id="BRHS_CODE">SS</Col>
			</Row>
		</Rows>
	</Dataset>
</Root>''';
}
