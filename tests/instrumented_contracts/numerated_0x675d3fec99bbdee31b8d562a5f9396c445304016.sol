1 pragma solidity ^0.4.2;
2 
3 contract owned {
4     address owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9     
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     
15     function transferOwnership(address _newOwner) onlyOwner {
16         owner = _newOwner;
17     }
18 }
19 
20 contract LuxToken is owned {
21     string public name = "Luxury Token";
22     string public symbol = "LUX";
23     uint8 public decimals = 0;
24     uint256 issuePrice = 1 ether / 100;
25 
26     bool public isAllowedToPurchase = false;
27 
28     uint256 minTokensRequiredForMessage = 10;
29     
30     mapping (address => uint256) public balanceOf;
31     mapping (address => string) messages;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event MessageAdded(address indexed from, string message, uint256 contributed);
35 
36     function LuxToken() {
37     }
38     
39     function transfer(address _to, uint256 _value) returns (bool success) {
40         if (_value == 0) { return false; }
41 
42         if (balanceOf[msg.sender] < _value) { return false; }
43         if (balanceOf[_to] + _value < balanceOf[_to]) { return false; }
44 
45         balanceOf[msg.sender] -= _value;
46         balanceOf[_to] += _value;
47 
48         Transfer(msg.sender, _to, _value);
49         return true;
50     }
51     
52     function enablePurchasing() onlyOwner {
53         isAllowedToPurchase = true;
54     }
55     
56     function disablePurchasing() onlyOwner {
57         isAllowedToPurchase = false;
58     }
59 
60     function () payable {
61         require(isAllowedToPurchase);
62 
63         uint256 issuedTokens = msg.value / issuePrice;
64         balanceOf[msg.sender] += issuedTokens;
65 
66         Transfer(address(this), msg.sender, 10);
67     }
68 
69     function getBalance(address addr) constant returns(uint256) {
70         return balanceOf[addr];
71     }
72     
73     function sendFundsTo(address _to, uint256 _amount) onlyOwner {
74         _to.transfer(_amount);
75     }
76     
77     function setMinTokensRequiredForMessage(uint256 _newValue) onlyOwner {
78         minTokensRequiredForMessage = _newValue;
79     }
80     
81     function setSymbol(string _symbol) onlyOwner {
82         symbol = _symbol;
83     }
84     
85     function setMessage(string _message) {
86         uint256 tokenBalance = balanceOf[msg.sender];
87         require(tokenBalance >= minTokensRequiredForMessage);
88         MessageAdded(msg.sender, _message, tokenBalance);
89     }
90 }