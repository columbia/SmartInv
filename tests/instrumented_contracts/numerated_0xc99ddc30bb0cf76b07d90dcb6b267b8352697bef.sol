1 pragma solidity ^0.4.11;
2 
3 contract TDT {
4     address public owner;
5     uint public supply = 10000000000000000000000000;
6     string public name = 'TDT';
7     string public symbol = 'TDT';
8     uint8 public decimals = 18;
9     uint public price = 1 finney;
10     uint public durationInBlocks = 157553; // 1 month
11     uint public amountRaised;
12     uint public deadline;
13     uint public tokensSold;
14     
15     /* This creates an array with all balances */
16     mapping (address => uint256) public balanceOf;
17     
18     mapping (address => mapping (address => uint256)) public allowance;
19     
20     /* This generates a public event on the blockchain that will notify clients */
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     
23     event FundTransfer(address backer, uint amount, bool isContribution);
24     
25     function isOwner() returns (bool isOwner) {
26         return msg.sender == owner;
27     }
28     
29     function addressIsOwner(address addr)  returns (bool isOwner) {
30         return addr == owner;
31     }
32 
33     modifier onlyOwner {
34         if (msg.sender != owner) revert();
35         _;
36     }
37 
38     function transferOwnership(address newOwner) onlyOwner {
39         owner = newOwner;
40     }
41     
42     /* Initializes contract with initial supply tokens to the creator of the contract */
43     function TDT() {
44         owner = msg.sender;
45         balanceOf[msg.sender] = supply;
46         deadline = block.number + durationInBlocks;
47     }
48     
49     function isCrowdsale() returns (bool isCrowdsale) {
50         return block.number < deadline;
51     }
52     
53     /* Internal transfer, only can be called by this contract */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         Transfer(_from, _to, _value);
68         // Asserts are used to use static analysis to find bugs in your code. They should never fail
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71     
72     /* Send coins */
73     function transfer(address _to, uint256 _value) {
74         _transfer(msg.sender, _to, _value);
75     }
76     
77     /* Transfer tokens from other address */
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         require(_value <= allowance[_from][msg.sender]);     // Check allowance
80         allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84     
85     /* Set allowance for other address */
86     function approve(address _spender, uint256 _value) public
87         returns (bool success) {
88         allowance[msg.sender][_spender] = _value;
89         return true;
90     }
91     
92     function () payable {
93         if (isOwner()) {
94             owner.transfer(amountRaised);
95             FundTransfer(owner, amountRaised, false);
96             amountRaised = 0;
97         } else if (isCrowdsale()) {
98             uint amount = msg.value;
99             if (amount == 0) revert();
100             
101             uint tokensCount = amount * 1000000000000000000 / price;
102             if (tokensCount < 1000000000000000000) revert();
103             
104             balanceOf[msg.sender] += tokensCount;
105             supply += tokensCount;
106             tokensSold += tokensCount;
107             Transfer(0, this, tokensCount);
108             Transfer(this, msg.sender, tokensCount);
109             amountRaised += amount;
110         } else {
111             revert();
112         }
113     }
114 }