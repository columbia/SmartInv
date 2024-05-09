1 pragma solidity ^0.4.18;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) public constant returns (uint256);
5 }
6 
7 contract Owned {
8     address public owner;
9     address public newOwner;
10 
11     event OwnershipTransferred(address indexed _from, address indexed _to);
12 
13     function Owned() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address _newOwner) public onlyOwner {
23         newOwner = _newOwner;
24     }
25 
26     function acceptOwnership() public {
27         require(msg.sender == newOwner);
28         emit OwnershipTransferred(owner, newOwner);
29         owner = newOwner;
30         newOwner = address(0);
31     }
32 }
33 
34 contract AMLOveCoinVoting is Owned {
35     address private _tokenAddress;
36     bool public votingAllowed = false;
37 
38     mapping (address => bool) yaVoto;
39     uint256 public votosTotales;
40     uint256 public donacionCruzRoja;
41     uint256 public donacionTeleton;
42     uint256 public inclusionEnExchange;
43 
44     function AMLOveCoinVoting(address tokenAddress) public {
45         _tokenAddress = tokenAddress;
46         votingAllowed = true;
47     }
48 
49     function enableVoting() onlyOwner public {
50         votingAllowed = true;
51     }
52 
53     function disableVoting() onlyOwner public {
54         votingAllowed = false;
55     }
56 
57     function vote(uint option) public {
58         require(votingAllowed);
59         require(option < 3);
60         require(!yaVoto[msg.sender]);
61         yaVoto[msg.sender] = true;
62         ForeignToken token = ForeignToken(_tokenAddress);
63         uint256 amount = token.balanceOf(msg.sender);
64         require(amount > 0);
65         votosTotales += amount;
66         if (option == 0){
67             donacionCruzRoja += amount;
68         } else if (option == 1) {
69             donacionTeleton += amount;
70         } else if (option == 2) {
71             inclusionEnExchange += amount;
72         } else {
73             assert(false);
74         }        
75     }
76     
77     function getStats() public view returns (
78         uint256 _votosTotales,
79         uint256 _donacionCruzRoja,
80         uint256 _donacionTeleton,
81         uint256 _inclusionEnExchange)
82     {
83         return (votosTotales, donacionCruzRoja, donacionTeleton, inclusionEnExchange);
84     }
85 }