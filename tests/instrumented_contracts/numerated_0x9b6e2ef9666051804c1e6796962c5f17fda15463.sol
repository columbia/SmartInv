1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { 
4     function receiveApproval(
5         address _from,
6         uint256 _value,
7         address _token, 
8         bytes _extraData
9         ) 
10         public; 
11 }
12 
13 contract AgurisToken {
14     string public constant name = "Aguris";
15     bytes32 public constant symbol = "AGS";
16     uint8 public decimals = 18;
17     uint256 public totalSupply;
18     mapping (address => uint256) public balanceOf;
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Burn(address indexed from, uint256 value);
22 
23     function AgurisToken() 
24     public 
25     {
26         totalSupply = 1999998 * 10 ** uint256(decimals);  // Making double to distribute 50% and burn
27         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
28     }
29 
30     function _transfer(address _from, address _to, uint _value)
31     internal 
32     {
33         require(_to != 0x0);
34         require(balanceOf[_from] >= _value);
35         require(balanceOf[_to] + _value > balanceOf[_to]);
36         uint previousBalances = balanceOf[_from] + balanceOf[_to];
37         balanceOf[_from] -= _value;
38         balanceOf[_to] += _value;
39         Transfer(_from, _to, _value);
40         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
41     }
42 
43     function transfer(address _to, uint256 _value)
44     public 
45     {
46         _transfer(msg.sender, _to, _value);
47     }
48     
49     function burn(uint256 _value) 
50     public 
51     returns (bool success) 
52     {
53         require(balanceOf[msg.sender] >= _value);   
54         balanceOf[msg.sender] -= _value;            
55         totalSupply -= _value;                      
56         Burn(msg.sender, _value);
57         return true;
58     }
59 }