1 pragma solidity ^0.4.21;
2 
3 contract owned {
4     address public godOwner;
5     mapping (address => bool) public owners;
6     
7     constructor() public{
8         godOwner = msg.sender;
9         owners[msg.sender] = true;
10     }
11     
12     modifier onlyGodOwner {
13         require(msg.sender == godOwner);
14         _;
15     }
16 
17     modifier onlyOwner {
18         require(owners[msg.sender] == true);
19         _;
20     }
21 
22     function addOwner(address _newOwner) onlyGodOwner public{
23         owners[_newOwner] = true;
24     }
25     
26     function removeOwner(address _oldOwner) onlyGodOwner public{
27         owners[_oldOwner] = false;
28     }
29     
30     function transferOwnership(address newGodOwner) public onlyGodOwner {
31         godOwner = newGodOwner;
32         owners[newGodOwner] = true;
33         owners[godOwner] = false;
34     }
35 }
36 
37 
38 contract ContractConn{
39     function transfer(address _to, uint _value) public;
40     function lock(address _to, uint256 _value) public;
41 }
42 
43 contract Airdrop is owned{
44     
45   constructor()  public payable{
46          
47   }
48     
49   function deposit() payable public{
50   }
51   
52   function doTransfers(address _tokenAddr, address[] _dests, uint256[] _values) onlyOwner public {
53     require(_dests.length >= 1 && _dests.length == _values.length,"doTransfers 1");
54     ContractConn conn = ContractConn(_tokenAddr);
55     uint256 i = 0;
56     while (i < _dests.length) {
57         conn.transfer(_dests[i], _values[i]);
58         i += 1;
59     }
60   }
61   
62   function doLocks(address _tokenAddr, address[] _dests, uint256[] _values) onlyOwner public{
63     require(_dests.length >= 1 && _dests.length == _values.length);
64     ContractConn conn = ContractConn(_tokenAddr);
65     uint256 i = 0;
66     while (i < _dests.length) {
67         conn.lock(_dests[i], _values[i]);
68         i += 1;
69     }
70   }
71   
72   function doWork(address _tokenAddr, string _method, address[] _dests, uint256[] _values) onlyOwner public{
73       require(_dests.length >= 1 && _dests.length == _values.length);
74       bytes4 methodID =  bytes4(keccak256(abi.encodePacked(_method)));
75       uint256 i = 0;
76       while(i < _dests.length){
77           if(!_tokenAddr.call(methodID, _dests[i], _values[i])){
78               revert();
79           }
80           i += 1;
81       }
82   }
83   
84   function extract(address _tokenAddr,address _to,uint256 _value) onlyOwner  public{
85       ContractConn conn = ContractConn(_tokenAddr);
86       conn.transfer(_to,_value);
87   }
88   
89   function extractEth(uint256 _value) onlyOwner  public{
90       msg.sender.transfer(_value);
91   }
92   
93 }