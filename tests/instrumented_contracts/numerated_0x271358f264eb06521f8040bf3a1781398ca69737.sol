1 pragma solidity 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'ExToke.com' Crowdsale contract
5 //
6 // Admin       	 : 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16
7 // fees      	 : zero (0)
8 // Start/End Time: None
9 // ExchangeRate  : 1 Token = 0.000001 ETH;
10 //
11 // Copyright (c) ExToke.com. The MIT Licence.
12 // Contract crafted by: GDO Infotech Pvt Ltd (https://GDO.co.in) 
13 // ----------------------------------------------------------------------------
14 
15     /**
16      * @title SafeMath
17      * @dev Math operations with safety checks that throw on error
18      */
19     library SafeMath {
20       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22           return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27       }
28     
29       function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34       }
35     
36       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39       }
40     
41       function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45       }
46     }
47     
48     contract owned {
49         address public owner;
50     	using SafeMath for uint256;
51     	
52         constructor() public {
53             owner = 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16;
54         }
55     
56         modifier onlyOwner {
57             require(msg.sender == owner);
58             _;
59         }
60     
61         function transferOwnership(address newOwner) onlyOwner public {
62             owner = newOwner;
63         }
64     }
65     
66     
67     interface token {
68     function transfer(address receiver, uint amount) external;
69     }
70     
71     contract ExTokeCrowdSale2 is owned {
72         // Public variables of the token
73         using SafeMath for uint256;
74 		uint256 public ExchangeRate=0.000001 * (1 ether);
75         token public tokenReward;
76         
77 		// This generates a public event on the blockchain that will notify clients
78         event Transfer(address indexed from, address indexed to, uint256 value);
79         
80         constructor (
81         address addressOfTokenUsedAsReward
82         ) public {
83         tokenReward = token(addressOfTokenUsedAsReward);
84         }
85         function () payable public{
86             uint256 ethervalue=msg.value;
87             uint256 tokenAmount=ethervalue.div(ExchangeRate);
88             tokenReward.transfer(msg.sender, tokenAmount.mul(1 ether));			// makes the transfers
89 			owner.transfer(msg.value);	//transfer the fund to admin
90         }
91         
92         function withdrawEtherManually()onlyOwner public{
93 		    require(msg.sender == owner); 
94 			uint256 amount=address(this).balance;
95 			owner.transfer(amount);
96 		}
97 		
98         function withdrawTokenManually(uint256 tokenAmount) onlyOwner public{
99             require(msg.sender == owner);
100             tokenReward.transfer(msg.sender,tokenAmount);
101         }
102         
103         function setExchangeRate(uint256 NewExchangeRate) onlyOwner public {
104             require(msg.sender == owner);
105 			ExchangeRate=NewExchangeRate;
106         }
107     }