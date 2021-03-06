let async = require('async'),
parseString = require('xml2js').parseString;

let util = require('../Utilities/util'),
shopTypeDAO = require('../DAO/shopTypeDAO');

/***API to get the shopType by shopTypeId */
let getShopType = (data, callback) => {
	async.auto({
		shopType: (cb) => {
			let criteria = {
				"id" : data.id
			}
			shopTypeDAO.getShopType(criteria,(err, data) => {
				if (err) {
					cb(null, {"statusCode": util.statusCode.FOUR_ZERO_ZERO,"statusMessage": util.statusMessage.BAD_REQUEST + err, "result": {} });
					return;
				}
				cb(null, {"statusCode": util.statusCode.OK,"statusMessage": util.statusMessage.SUCCESS, "result": data });
				return;
								
			});
		}
	}, (err, response) => {
		callback(response.shopType);
	})
}

module.exports = {
	getShopType : getShopType
};