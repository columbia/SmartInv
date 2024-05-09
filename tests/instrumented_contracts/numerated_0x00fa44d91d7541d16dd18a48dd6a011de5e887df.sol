1 pragma solidity ^0.4.13;
2 
3 contract Calculator {
4     function getAmount(uint value) constant returns (uint);
5 }
6 
7 contract Ownable {
8   address public owner;
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner {
34     require(newOwner != address(0));      
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) constant returns (uint256);
43   function transfer(address to, uint256 value) returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) constant returns (uint256);
49   function transferFrom(address from, address to, uint256 value) returns (bool);
50   function approve(address spender, uint256 value) returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract Sale is Ownable {
55 
56     //responsible for getting token amount
57     Calculator calculator;
58 
59     //which token should we sell
60     ERC20 token;
61 
62     // who sells his tokens
63     address tokenSeller;
64 
65     uint256 public minimalTokens = 100000000000;
66 
67     /**
68      * event for token purchase logging
69      * @param purchaser who paid for the tokens
70      * @param value weis paid for purchase
71      * @param amount amount of tokens purchased
72      */
73     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
74 
75     function Sale(address tokenAddress, address calculatorAddress) {
76         tokenSeller = msg.sender;
77         token = ERC20(tokenAddress);
78         setCalculatorAddress(calculatorAddress);
79     }
80 
81     function () payable {
82         buyTokens();
83     }
84 
85     function buyTokens() payable {
86         uint256 weiAmount = msg.value;
87 
88         // calculate token amount to be created
89         uint256 tokens = calculator.getAmount(weiAmount);
90         assert(tokens >= minimalTokens);
91 
92         token.transferFrom(tokenSeller, msg.sender, tokens);
93         TokenPurchase(msg.sender, weiAmount, tokens);
94     }
95 
96     function setTokenSeller(address newTokenSeller) onlyOwner {
97         tokenSeller = newTokenSeller;
98     }
99 
100     function setCalculatorAddress(address calculatorAddress) onlyOwner {
101         calculator = Calculator(calculatorAddress);
102     }
103 
104     function setMinimalTokens(uint256 _minimalTokens) onlyOwner {
105         minimalTokens = _minimalTokens;
106     }
107 
108     function withdraw(address beneficiary, uint amount) onlyOwner {
109         require(beneficiary != 0x0);
110 
111         beneficiary.transfer(amount);
112     }
113 }