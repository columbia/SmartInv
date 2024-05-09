1 pragma solidity ^0.4.17;
2 
3 contract EtherCard {
4 
5   struct Gift {
6       uint256 amount;
7       uint256 amountToRedeem;
8       bool redeemed;
9       address from;
10   }
11   
12   // Who created this contract
13   address public owner;
14   mapping (bytes32 => Gift) gifts;
15   uint256 feeAmount;
16 
17   function EtherCard() public {
18     owner = msg.sender;
19     feeAmount = 100; //1% of the gift amount
20   }
21 
22   function getBalance() public view returns (uint256) {
23       return this.balance;
24   }
25 
26   function getAmountByCoupon(bytes32 hash) public view returns (uint256) {
27       return gifts[hash].amountToRedeem;
28   }
29 
30   function getRedemptionStatus(bytes32 hash) public view returns (bool) {
31       return gifts[hash].redeemed;
32   }
33 
34   // Called when someone tries to redeem the gift
35   function redeemGift(string coupon, address wallet) public returns (uint256) {
36       bytes32 hash = keccak256(coupon);
37       Gift storage gift = gifts[hash];
38       if ((gift.amount <= 0) || gift.redeemed) {
39           return 0;
40       }
41       uint256 amount = gift.amountToRedeem;
42       wallet.transfer(amount);
43       gift.redeemed = true;
44       return amount;
45   }
46 
47   // Called when someone sends ETH to this contract function
48   function createGift(bytes32 hashedCoupon) public payable {
49         if (msg.value * 1000 < 1) { // Send minimum 0.001 ETH
50             return;
51         }
52         uint256 calculatedFees = msg.value/feeAmount;
53         
54         var gift = gifts[hashedCoupon];
55         gift.amount = msg.value;
56         gift.amountToRedeem = msg.value - calculatedFees;
57         gift.from = msg.sender;
58         gift.redeemed = false;
59 
60         //Transfer ether to owner
61         owner.transfer(calculatedFees);                
62   }
63 }