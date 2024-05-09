1 pragma solidity ^0.4.11;
2 
3 contract TronToken {
4 
5     // string public name = "Tronix";      //  token name
6    //  string public symbol = "TRX";           //  token symbol
7   //  uint256 public decimals = 6;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10    
11 
12     uint256 public totalSupply = 0;
13     bool public stopped = false;
14 
15     uint256 constant valueFounder = 100000000000000000;
16     address owner = 0x0;
17 
18   
19 
20     modifier isRunning {
21         assert (!stopped);
22         _;
23     }
24 
25     modifier validAddress {
26         assert(0x0 != msg.sender);
27         _;
28     }
29 
30     function TronToken(address _addressFounder) public {
31         owner = msg.sender;
32         totalSupply = valueFounder;
33         balanceOf[_addressFounder] = valueFounder;
34         Transfer(0x0, _addressFounder, valueFounder);
35     }
36    
37     
38 
39     function transfer(address _to, uint256 _value) isRunning validAddress  payable returns (bool success) {
40         require(balanceOf[msg.sender] >= _value);
41         require(balanceOf[_to] + _value >= balanceOf[_to]);
42         balanceOf[msg.sender] -= _value;
43         balanceOf[_to] += _value;
44         Transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48     
49 
50    
51    
52 
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54    
55 }