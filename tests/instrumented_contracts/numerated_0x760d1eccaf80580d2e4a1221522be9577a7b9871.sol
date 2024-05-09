1 pragma solidity ^0.4.16;
2 
3 contract VI6 {
4     string public name = "VISix";      
5     string public symbol = "VI6";              
6     uint8 public decimals = 6;                
7     uint256 public totalSupply;                
8 
9 
10     bool public lockAll = false;               
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event FrozenFunds(address target, bool frozen);
14     event OwnerUpdate(address _prevOwner, address _newOwner);
15     address public owner;
16     address internal newOwner = 0x0;
17     mapping (address => bool) public frozens;
18     mapping (address => uint256) public balanceOf;
19 
20     //---------init----------
21     function VI6() public {
22         totalSupply = 1000000000 * 10 ** uint256(decimals);  
23         balanceOf[msg.sender] = totalSupply;                
24         owner = msg.sender;
25     }
26     //--------control--------
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31     function transferOwnership(address tOwner) onlyOwner public {
32         require(owner!=tOwner);
33         newOwner = tOwner;
34     }
35     function acceptOwnership() public {
36         require(msg.sender==newOwner && newOwner != 0x0);
37         owner = newOwner;
38         newOwner = 0x0;
39         emit OwnerUpdate(owner, newOwner);
40     }
41     function freezeAccount(address target, bool freeze) onlyOwner public {
42         frozens[target] = freeze;
43         emit FrozenFunds(target, freeze);
44     }
45     function freezeAll(bool lock) onlyOwner public {
46         lockAll = lock;
47     }
48     //-------transfer-------
49     function transfer(address _to, uint256 _value) public {
50         _transfer(msg.sender, _to, _value);
51     }
52     function _transfer(address _from, address _to, uint _value) internal {
53         require(!lockAll);
54         require(_to != 0x0);
55         require(balanceOf[_from] >= _value);
56         require(balanceOf[_to] + _value >= balanceOf[_to]);
57         require(!frozens[_from]); 
58         //require(!frozenAccount[_to]);  
59         uint previousBalances = balanceOf[_from] + balanceOf[_to];
60         balanceOf[_from] -= _value;
61         balanceOf[_to] += _value;
62         emit Transfer(_from, _to, _value);
63         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
64     }
65 }