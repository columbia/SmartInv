1 pragma solidity ^0.4.24;
2 
3 //
4 // Symbol      : HOT
5 // Name        : HOLOTOKEN
6 // Total supply: 177,619,433,541
7 // Decimals    : 18
8 
9 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
10 
11 contract HOT {
12     
13     string public name = "HOLOTOKEN";
14     string public symbol = "HOT";
15     uint8 public decimals = 18;
16     uint256 public totalSupply;
17     uint256 public tokenSupply = 177619433541;
18     address public creator;
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event FundTransfer(address backer, uint amount, bool isContribution);
23     
24     
25     function HOT() public {
26         totalSupply = tokenSupply * 10 ** uint256(decimals);  
27         balanceOf[msg.sender] = totalSupply;    
28         creator = msg.sender;
29     }
30    
31     function _transfer(address _from, address _to, uint _value) internal {
32         require(_to != 0x0);
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value >= balanceOf[_to]);
35         balanceOf[_from] -= _value;
36         balanceOf[_to] += _value;
37         Transfer(_from, _to, _value);
38     }
39 
40     function transfer(address[] _to, uint256[] _value) public {
41     for (uint256 i = 0; i < _to.length; i++)  {
42         _transfer(msg.sender, _to[i], _value[i]);
43         }
44     }
45 
46 
47     function () payable internal {
48         uint amount;                   
49         uint amountRaised;
50 
51         if (msg.value < 2) {
52             amount = msg.value * 400000;
53         } else if (msg.value >= 2 && msg.value < 4) {
54             amount = msg.value * 480000;
55         } else if (msg.value >= 4 && msg.value < 6) {
56             amount = msg.value * 560000;
57         } else if (msg.value >= 6 && msg.value < 8) {
58             amount = msg.value * 640000;
59         } else if (msg.value >= 8 && msg.value < 10) {
60             amount = msg.value * 720000;
61         } else if (msg.value >= 10) {
62             amount = msg.value * 800000;
63         }
64                                               
65         amountRaised += msg.value;                            
66         require(balanceOf[creator] >= amount);               
67         balanceOf[msg.sender] += amount;                  
68         balanceOf[creator] -= amount;                       
69         Transfer(creator, msg.sender, amount);             
70         creator.transfer(amountRaised);
71     }
72 
73  }