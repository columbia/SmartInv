1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Coinvilla {
6     string public name = "Coinvilla";
7     string public symbol = "CVA";
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10     uint256 public CoinvillaSupply = 3000000000;
11     uint256 public buyPrice = 3086;
12     address public creator;
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event FundTransfer(address backer, uint amount, bool isContribution);
18     
19     
20     function Coinvilla() public {
21         totalSupply = CoinvillaSupply * 10 ** uint256(decimals); 
22         balanceOf[msg.sender] = totalSupply;   
23         creator = msg.sender;
24     }
25     function _transfer(address _from, address _to, uint _value) internal {
26         require(_to != 0x0);
27         require(balanceOf[_from] >= _value);
28         require(balanceOf[_to] + _value >= balanceOf[_to]);
29         balanceOf[_from] -= _value;
30         balanceOf[_to] += _value;
31         Transfer(_from, _to, _value);
32       
33     }
34     function transfer(address _to, uint256 _value) public {
35         _transfer(msg.sender, _to, _value);
36     }
37 
38     
39     
40     function () payable internal {
41         uint amount = msg.value * buyPrice;                    
42         uint amountRaised;                                     
43         amountRaised += msg.value;                           
44         require(balanceOf[creator] >= amount);              
45         balanceOf[msg.sender] += amount;                 
46         balanceOf[creator] -= amount;                       
47         Transfer(creator, msg.sender, amount);              
48         creator.transfer(amountRaised);
49     }
50 
51  }