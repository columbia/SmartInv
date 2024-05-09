1 pragma solidity ^0.4.21;
2 
3 
4 contract owned {
5 
6     mapping (address => bool) internal owners;
7     
8     constructor() public{
9         owners[msg.sender] = true;
10     }
11 
12     modifier onlyOwner {
13         require(owners[msg.sender] == true);
14         _;
15     }
16 
17     function addOwner(address _newOwner) onlyOwner public{
18         owners[_newOwner] = true;
19     }
20     
21     function removeOwner(address _oldOwner) onlyOwner public{
22         owners[_oldOwner] = false;
23     }
24 }
25 
26 
27 contract ContractConn{
28     function transfer(address _to, uint _value) public returns (bool success);
29 }
30 
31 contract Airdrop is owned{
32     
33    constructor()  public payable{
34          
35    }
36     
37   function deposit() payable public{
38   }
39   
40   function doAirdrop(address _tokenAddr, address[] _dests, uint256[] _values) onlyOwner public {
41     ContractConn usb = ContractConn(_tokenAddr);
42     uint256 i = 0;
43     while (i < _dests.length) {
44         usb.transfer(_dests[i], _values[i]);
45         i += 1;
46     }
47   }
48   
49   function extract(address _tokenAddr,address _to,uint256 _value) onlyOwner  public{
50       ContractConn usb = ContractConn(_tokenAddr);
51       usb.transfer(_to,_value);
52   }
53   
54   function extractEth(uint256 _value) onlyOwner  public{
55       msg.sender.transfer(_value);
56   }
57   
58 }