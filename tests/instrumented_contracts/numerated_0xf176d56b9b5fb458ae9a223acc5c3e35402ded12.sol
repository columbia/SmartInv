1 pragma solidity 0.7.4;
2 // SPDX-License-Identifier: MIT
3 
4 interface IESDS {
5     function redeemCoupons(uint256 epoch, uint256 couponAmount) external;
6     function transferCoupons(address sender, address recipient, uint256 epoch, uint256 amount) external;
7 }
8 
9 interface IERC20 {
10     function transfer(address recipient, uint256 amount) external returns (bool);
11 }
12 
13 // @notice Lets anybody trustlessly redeem coupons on anyone else's behalf for a fee (default fee is 1%).
14 //    Requires that the coupon holder has previously approved this contract via the ESDS `approveCoupons` function.
15 // @dev Bots should scan for the `CouponApproval` event emitted by the ESDS `approveCoupons` function to find out which 
16 //    users have approved this contract to redeem their coupons.
17 contract CouponClipper {
18 
19     IERC20 constant private ESD = IERC20(0x36F3FD68E7325a35EB768F1AedaAe9EA0689d723);
20     IESDS constant private ESDS = IESDS(0x443D2f2755DB5942601fa062Cc248aAA153313D3);
21 
22     // The percent fee offered by coupon holders to callers (bots), in basis points
23     // E.g., offers[_user] = 500 indicates that _user will pay 500 basis points (5%) to the caller
24     mapping(address => uint256) private offers;
25 
26     // @notice Gets the number of basis points the _user is offering the bots
27     // @dev The default value is 100 basis points (1%).
28     //   That is, `offers[_user] = 0` is interpretted as 1%.
29     //   This way users who are comfortable with the default 1% offer don't have to make any additional contract calls.
30     // @param _user The account whose offer we're looking up.
31     // @return The number of basis points the account is offering the callers (bots)
32     function getOffer(address _user) public view returns (uint256) {
33         uint256 offer = offers[_user];
34         return offer == 0 ? 100 : offer;
35     }
36 
37     // @notice Allows msg.sender to change the number of basis points they are offering.
38     // @dev An _offer value of 0 will be interpretted as the "default offer", which is 100 basis points (1%).
39     // @param _offer The number of basis points msg.sender wants to offer the callers (bots).
40     function setOffer(uint256 _offer) external {
41         require(_offer <= 10_000, "Offer exceeds 100%.");
42         offers[msg.sender] = _offer;
43     }
44 
45     // @notice Allows anyone to redeem coupons for ESD on the coupon-holder's bahalf
46     // @param _user Address of the user holding the coupons (and who has approved this contract)
47     // @param _epoch The epoch in which the _user purchased the coupons
48     // @param _couponAmount The number of coupons to redeem (18 decimals)
49     function redeem(address _user, uint256 _epoch, uint256 _couponAmount) external {
50         
51         // pull user's coupons into this contract (requires that the user has approved this contract)
52         ESDS.transferCoupons(_user, address(this), _epoch, _couponAmount);
53         
54         // redeem the coupons for ESD
55         ESDS.redeemCoupons(_epoch, _couponAmount);
56         
57         // pay the caller their fee
58         uint256 botFee = _couponAmount * getOffer(_user) / 10_000;
59         ESD.transfer(msg.sender, botFee); // @audit-ok : reverts on failure
60         
61         // send the ESD to the user
62         ESD.transfer(_user, _couponAmount - botFee); // @audit-ok : no underflow and reverts on failure
63     }
64 }