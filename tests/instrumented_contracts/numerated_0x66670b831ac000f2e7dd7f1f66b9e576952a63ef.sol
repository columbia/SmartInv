1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract BIXCPRO {
6 
7     string public name = "Bixcoin Pro";
8     string public symbol = "BIXCPRO";
9     uint8 public decimals = 4;
10 
11     uint256 public totalSupply;
12     uint256 public bixcproSupply = 68999899;
13     uint256 public buyPrice = 50;
14     address public creator;
15 
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event FundTransfer(address backer, uint amount, bool isContribution);
22     
23     
24   
25     function BIXCPRO () public {
26         totalSupply = bixcproSupply * 10 ** uint256(decimals);  
27         balanceOf[msg.sender] = totalSupply;
28         creator = msg.sender;
29     }
30 
31     function _transfer(address _from, address _to, uint _value) internal {
32         require(_to != 0x0); //Burn
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value >= balanceOf[_to]);
35         balanceOf[_from] -= _value;
36         balanceOf[_to] += _value;
37         Transfer(_from, _to, _value);
38       
39     }
40 
41     function transfer(address _to, uint256 _value) public {
42         _transfer(msg.sender, _to, _value);
43     }
44 
45     
46     
47  
48     function () payable internal {
49         uint amount = msg.value * buyPrice ;                    
50         uint amountRaised;                                     
51         amountRaised += msg.value;                            
52         require(balanceOf[creator] >= amount);               
53         require(msg.value >=0);                        
54         balanceOf[msg.sender] += amount;                  
55         balanceOf[creator] -= amount;                        
56         Transfer(creator, msg.sender, amount);               
57         creator.transfer(amountRaised);
58     }    
59     
60  }