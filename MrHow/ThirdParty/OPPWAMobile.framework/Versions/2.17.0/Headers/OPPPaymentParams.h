//
// Copyright (c) 2018 by ACI Worldwide, Inc.
// All rights reserved.
//
// This software is the confidential and proprietary information
// of ACI Worldwide Inc ("Confidential Information"). You shall
// not disclose such Confidential Information and shall use it
// only in accordance with the terms of the license agreement
// you entered with ACI Worldwide Inc.
//

#import <Foundation/Foundation.h>


DEPRECATED_MSG_ATTRIBUTE("The OPPPaymentParamsBrand class is formally deprecated. Use string values for the payment brands.")
/**
 An enumeration for the various payment brands.
 
 **Important:** _The OPPPaymentParamsBrand class is formally deprecated in 1.4.0. Use string values for the payment brands._
 */
typedef NS_ENUM(NSInteger, OPPPaymentParamsBrand) {
    /// VISA card payment brand.
    OPPPaymentParamsBrandVISA DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"VISA\" instead of."),
    /// MasterCard payment brand.
    OPPPaymentParamsBrandMasterCard DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"MASTER\" instead of."),
    /// American Express card brand.
    OPPPaymentParamsBrandAMEX DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"AMEX\" instead of."),
    /// Diners Club card brand.
    OPPPaymentParamsBrandDinersClub DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"DINERS\" instead of."),
    /// Discover card brand.
    OPPPaymentParamsBrandDiscover DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"DISCOVER\" instead of."),
    /// UnionPay (ExpressPay) card brand.
    OPPPaymentParamsBrandUnionPay DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"UNIONPAY\" instead of."),
    /// JCB card brand.
    OPPPaymentParamsBrandJCB DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"JCB\" instead of."),
    
    /// SEPA direct debit payment brand.
    OPPPaymentParamsBrandDirectDebitSEPA DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"DIRECTDEBIT_SEPA\" instead of."),
    /// SOFORT banking payment brand.
    OPPPaymentParamsBrandSOFORTBanking DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"SOFORTUEBERWEISUNG\" instead of."),
    /// BOLETO payment brand.
    OPPPaymentParamsBrandBOLETO DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"BOLETO\" instead of."),
    /// IDEAL payment brand.
    OPPPaymentParamsBrandIDEAL DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"IDEAL\" instead of."),
    
    /// Apple pay payment brand.
    OPPPaymentParamsBrandApplePay DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"APPLEPAY\" instead of."),
    
    /// PayPal payment brand.
    OPPPaymentParamsBrandPayPal DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"PAYPAL\" instead of."),
    /// China UnionPay brand.
    OPPPaymentParamsBrandChinaUnionPay DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"CHINAUNIONPAY\" instead of."),
    
    /// Alipay payment brand.
    OPPPaymentParamsBrandAlipay DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"ALIPAY\" instead of."),
    
    /// Unsupported payment brand.
    OPPPaymentParamsBrandUnknown DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used.")
};

/**
 Class to represent a set of parameters needed for performing an e-commerce transaction.
 */

NS_ASSUME_NONNULL_BEGIN
@interface OPPPaymentParams : NSObject

/** @name Initialization */

- (instancetype)init NS_UNAVAILABLE;

/**
 Creates an object representing a payment transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param paymentBrand The payment brand of the transaction.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing a payment transaction, and nil if parameters are invalid.
 */
+ (nullable instancetype)paymentParamsWithCheckoutID:(NSString *)checkoutID paymentBrand:(NSString *)paymentBrand error:(NSError **)error;

/**
 Creates an object representing a payment transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param paymentBrand The payment brand of the transaction.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing a payment transaction, and nil if parameters are invalid.
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID paymentBrand:(NSString *)paymentBrand error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/** @name Properties */

/** A property that can be set with a value from initial checkout request (mandatory). This value is required in the next steps. */
@property (nonatomic, copy, readonly) NSString *checkoutID;

/**
 The payment brand of the transaction.
 */
@property (nonatomic, copy, readonly) NSString *paymentBrand;

/** 
 Method of payment for the request.
 @deprecated Use paymentBrand instead
 @see paymentBrand
 */
@property (nonatomic, readonly) OPPPaymentParamsBrand brand DEPRECATED_ATTRIBUTE;

/**
 Dictionary of custom parameters that will be sent to the server.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *customParams;

/** @name Custom parameters methods */

/**
 Method to add custom parameter that will be sent to the server.
 @param name Name should be prepended with SHOPPER_*, e.g. SHOPPER_customerId. Expected string that matches regex SHOPPER_[0-9a-zA-Z._]{3,64}.
 @param value Any string no longer than 2048 characters.
 @return Returns YES if name and value are valid and parameter is successfully saved, otherwise NO.
 */
- (BOOL)addCustomParamWithName:(NSString *)name value:(NSString *)value;

/**
 Method to remove record from the dictionary of custom parameters.
 @param name Parameter name.
 */
- (void)removeCustomParamWithName:(NSString *)name;

/** @name Helper methods */

/**
 Helper method to mask sensitive payment details such as card number, CVV and etc.
 */
- (void)mask;

@end
NS_ASSUME_NONNULL_END
