1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Ownable {
8 
9     address public owner;
10 
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19     
20 }
21 
22 contract IQNSecondPreICO is Ownable {
23     
24     uint256 public constant EXCHANGE_RATE = 550;
25     uint256 public constant START = 1515402000; // Monday, 08-Jan-18 09:00:00 UTC in RFC 2822
26 
27 
28 
29     uint256 availableTokens;
30     address addressToSendEthereum;
31     address addressToSendTokenAfterIco;
32     
33     uint public amountRaised;
34     uint public deadline;
35     uint public price;
36     token public tokenReward;
37     mapping(address => uint256) public balanceOf;
38     bool crowdsaleClosed = false;
39 
40     /**
41      * Constrctor function
42      *
43      * Setup the owner
44      */
45     function IQNSecondPreICO (
46         address addressOfTokenUsedAsReward,
47         address _addressToSendEthereum,
48         address _addressToSendTokenAfterIco
49     ) public {
50         availableTokens = 800000 * 10 ** 18;
51         addressToSendEthereum = _addressToSendEthereum;
52         addressToSendTokenAfterIco = _addressToSendTokenAfterIco;
53         deadline = START + 7 days;
54         tokenReward = token(addressOfTokenUsedAsReward);
55     }
56 
57     /**
58      * Fallback function
59      *
60      * The function without name is the default function that is called whenever anyone sends funds to a contract
61      */
62     function () public payable {
63         require(now < deadline && now >= START);
64         require(msg.value >= 1 ether);
65         uint amount = msg.value;
66         balanceOf[msg.sender] += amount;
67         amountRaised += amount;
68         availableTokens -= amount;
69         tokenReward.transfer(msg.sender, amount * EXCHANGE_RATE);
70         addressToSendEthereum.transfer(amount);
71     }
72 
73     modifier afterDeadline() { 
74         require(now >= deadline);
75         _; 
76     }
77 
78     function sendAfterIco(uint amount)  public payable onlyOwner afterDeadline
79     {
80         tokenReward.transfer(addressToSendTokenAfterIco, amount);
81     }
82     
83     function sellForBitcoin(address _address,uint amount)  public payable onlyOwner
84     {
85         tokenReward.transfer(_address, amount);
86     }
87 
88     function tokensAvailable() public constant returns (uint256) {
89         return availableTokens;
90     }
91 
92 }