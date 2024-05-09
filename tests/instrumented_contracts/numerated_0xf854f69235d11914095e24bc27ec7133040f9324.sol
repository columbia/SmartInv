1 pragma solidity 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'ExToke.com' Crowdsale contract
5 //
6 // Admin       	 : 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16
7 // fees      	 : zero (0)
8 // ICO StartTime : 1530075600;   // 06/27/2018 @ 5:00am (UTC)
9 // ICO EndTime   : 1532217540;   // 07/21/2018 @ 11:59pm (UTC)
10 // ExchangeRate  : 1 Token = 0.000001 ETH;
11 //
12 // Copyright (c) ExToke.com. The MIT Licence.
13 // Contract crafted by: GDO Infotech Pvt Ltd (https://GDO.co.in) 
14 // ----------------------------------------------------------------------------
15 
16     /**
17      * @title SafeMath
18      * @dev Math operations with safety checks that throw on error
19      */
20     library SafeMath {
21       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23           return 0;
24         }
25         uint256 c = a * b;
26         assert(c / a == b);
27         return c;
28       }
29     
30       function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35       }
36     
37       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40       }
41     
42       function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46       }
47     }
48     
49     contract owned {
50         address public owner;
51     	using SafeMath for uint256;
52     	
53         constructor() public {
54             owner = msg.sender;
55         }
56     
57         modifier onlyOwner {
58             require(msg.sender == owner);
59             _;
60         }
61     
62         function transferOwnership(address newOwner) onlyOwner public {
63             owner = newOwner;
64         }
65     }
66     
67     
68     interface token {
69     function transfer(address receiver, uint amount) external;
70     }
71     
72     contract ExTokeCrowdSale is owned {
73         // Public variables of the token
74         using SafeMath for uint256;
75     	uint256 public startTime = 1530075600; // 06/27/2018 @ 5:00am (UTC)
76     	uint256 public EndTime = 1532217540;   // 07/21/2018 @ 11:59pm (UTC)
77 		uint256 public ExchangeRate=0.000001 * (1 ether);
78         token public tokenReward;
79         
80 		// This generates a public event on the blockchain that will notify clients
81         event Transfer(address indexed from, address indexed to, uint256 value);
82         
83         constructor (
84         address addressOfTokenUsedAsReward
85         ) public {
86         tokenReward = token(addressOfTokenUsedAsReward);
87         }
88         function () payable public{
89              require(EndTime > now);
90              require (startTime < now);
91             uint256 ethervalue=msg.value;
92             uint256 tokenAmount=ethervalue.div(ExchangeRate);
93             tokenReward.transfer(msg.sender, tokenAmount.mul(1 ether));			// makes the transfers
94 			owner.transfer(msg.value);	//transfer the fund to admin
95         }
96         
97         function withdrawEtherManually()onlyOwner public{
98 		    require(msg.sender == owner); 
99 			uint256 amount=address(this).balance;
100 			owner.transfer(amount);
101 		}
102 		
103         function withdrawTokenManually(uint256 tokenAmount) onlyOwner public{
104             require(msg.sender == owner);
105             tokenReward.transfer(msg.sender,tokenAmount);
106         }
107         
108         function setExchangeRate(uint256 NewExchangeRate) onlyOwner public {
109             require(msg.sender == owner);
110 			ExchangeRate=NewExchangeRate;
111         }
112     }