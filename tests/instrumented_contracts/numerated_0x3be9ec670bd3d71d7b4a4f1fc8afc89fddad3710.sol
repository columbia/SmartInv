1 pragma solidity ^0.4.16;
2 
3 contract SuperEOS {
4     string public name = "SuperEOS";      
5     string public symbol = "SPEOS";              
6     uint8 public decimals = 6;                
7     uint256 public totalSupply;                
8 
9     bool public lockAll = false;               
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event FrozenFunds(address target, bool frozen);
13     event OwnerUpdate(address _prevOwner, address _newOwner);
14     address public owner;
15     address internal newOwner = 0x0;
16     mapping (address => bool) public frozens;
17     mapping (address => uint256) public balanceOf;
18 
19     //---------init----------
20     function SuperEOS() public {
21         totalSupply = 2000000000 * 10 ** uint256(decimals);  
22         balanceOf[msg.sender] = totalSupply;                
23         owner = msg.sender;
24     }
25     //--------control--------
26     modifier onlyOwner {
27         require(msg.sender == owner);
28         _;
29     }
30     function transferOwnership(address tOwner) onlyOwner public {
31         require(owner!=tOwner);
32         newOwner = tOwner;
33     }
34     function acceptOwnership() public {
35         require(msg.sender==newOwner && newOwner != 0x0);
36         owner = newOwner;
37         newOwner = 0x0;
38         emit OwnerUpdate(owner, newOwner);
39     }
40 
41     function freezeAccount(address target, bool freeze) onlyOwner public {
42         frozens[target] = freeze;
43         emit FrozenFunds(target, freeze);
44     }
45 
46     function freezeAll(bool lock) onlyOwner public {
47         lockAll = lock;
48     }
49 
50     //-------transfer-------
51     function transfer(address _to, uint256 _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54     function _transfer(address _from, address _to, uint _value) internal {
55         require(!lockAll);
56         require(_to != 0x0);
57         require(balanceOf[_from] >= _value);
58         require(balanceOf[_to] + _value >= balanceOf[_to]);
59         require(!frozens[_from]); 
60 
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         balanceOf[_from] -= _value;
63         balanceOf[_to] += _value;
64         emit Transfer(_from, _to, _value);
65         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
66     }
67 }