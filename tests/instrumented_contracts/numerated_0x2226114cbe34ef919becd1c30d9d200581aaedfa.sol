1 pragma solidity ^0.4.19;
2 contract tokenRecipient { 
3     
4     function receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) public; 
5     }
6 
7 contract VICOToken {
8 
9 	string public name = 'VICO Vote Token';
10     	string public symbol = 'VICO';
11     	uint256 public decimals = 0;
12     	uint256 public totalSupply = 100000000;
13     	address public VicoOwner;
14         mapping (address => uint256) public balanceOf;
15         mapping (address => mapping (address => uint256)) public allowance;
16         event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     function VICOToken(address ownerAddress) public {
19         balanceOf[msg.sender] = totalSupply;
20         VicoOwner = ownerAddress;
21     }
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24         require (_to != 0x0);                               
25         require (_value >0);
26         require (balanceOf[msg.sender] >= _value);           
27         require (balanceOf[_to] + _value > balanceOf[_to]); 
28         balanceOf[msg.sender] -= _value;                     
29         balanceOf[_to] += _value;                           
30         Transfer(msg.sender, _to, _value);                   
31         return true;
32     }
33 
34     function transferFrom (address _from, address _to, uint256 _value) public returns (bool success) {
35         require (_to != 0x0);                             
36         require (_value >0);
37         require (balanceOf[_from] >= _value);
38         require (balanceOf[_to] + _value > balanceOf[_to]);
39         require (_value <= allowance[_from][msg.sender]);    
40         balanceOf[_from] -= _value;
41         balanceOf[_to] += _value; 
42         allowance[_from][msg.sender] -= _value;
43         Transfer(_from, _to, _value);
44         return true;
45     }
46 
47 }