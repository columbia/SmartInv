1 pragma solidity ^0.4.16;
2 
3 contract SSOrgToken {
4     // Public variables of the token
5     address public owner;
6     string public name;
7     string public symbol;
8     uint8 public constant decimals = 2;
9     uint256 public totalSupply;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => uint8) public sellTypeOf;
14     mapping (address => uint256) public sellTotalOf;
15     mapping (address => uint256) public sellPriceOf;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * Constrctor function
22      *
23      * Initializes contract with initial supply tokens to the creator of the contract
24      */
25     function SSOrgToken(
26         string tokenName,
27         string tokenSymbol,
28         uint256 tokenSupply
29     ) public {
30         name = tokenName;
31         symbol = tokenSymbol;
32         totalSupply = tokenSupply * 10 ** uint256(decimals);
33         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
34         owner = msg.sender;
35     }
36 
37     /**
38      * Transfer tokens
39      *
40      * Send `_value` tokens to `_to` from your account
41      *
42      * @param _to The address of the recipient
43      * @param _value the amount to send
44      */
45     function transfer(address _to, uint256 _value) public returns (bool) {
46         // Prevent transfer to 0x0 address. Use burn() instead
47         require(_to != 0x0);
48         // Check if the sender has enough
49         require(balanceOf[msg.sender] >= _value);
50         // Check for overflows
51         require(balanceOf[_to] + _value > balanceOf[_to]);
52         // Subtract from the sender
53         balanceOf[msg.sender] -= _value;
54         // Add the same to the recipient
55         balanceOf[_to] += _value;
56         Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     function setSellInfo(uint8 newSellType, uint256 newSellTotal, uint256 newSellPrice) public returns (uint256) {
61         require(newSellPrice > 0 && newSellTotal >= 0);
62         if (newSellTotal > sellTotalOf[msg.sender]) {
63             require(balanceOf[msg.sender] >= newSellTotal - sellTotalOf[msg.sender]);
64             balanceOf[msg.sender] -= newSellTotal - sellTotalOf[msg.sender];
65         } else {
66             balanceOf[msg.sender] += sellTotalOf[msg.sender] - newSellTotal;
67         }
68         sellTotalOf[msg.sender] = newSellTotal;
69         sellPriceOf[msg.sender] = newSellPrice;
70         sellTypeOf[msg.sender] = newSellType;
71         return balanceOf[msg.sender];
72     }
73 
74     function buy(address seller) payable public returns (uint256 amount) {
75         amount = msg.value / sellPriceOf[seller];        // calculates the amount
76         require(sellTypeOf[seller] == 0 ? sellTotalOf[seller] == amount : sellTotalOf[seller] >= amount);
77         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
78         sellTotalOf[seller] -= amount;                        // subtracts amount from seller's balance
79         Transfer(seller, msg.sender, amount);               // execute an event reflecting the change
80         seller.transfer(msg.value);
81         return amount;                                    // ends function and returns
82     }
83 }