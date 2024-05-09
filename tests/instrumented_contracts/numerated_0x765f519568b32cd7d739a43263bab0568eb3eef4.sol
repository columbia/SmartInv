1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4     
5     string public name;
6     function totalSupply() constant returns (uint);
7     function balanceOf(address _owner) constant returns (uint);
8     function allowance(address _owner, address _spender) constant returns (uint);
9     function transfer(address _to, uint _value) returns (bool);
10     function transferFrom(address _from, address _to, uint _value) returns (bool);
11     function approve(address _spender, uint _value) returns (bool);
12 
13 }
14 
15 contract Ownable {
16 
17     address public owner;
18 
19     function Ownable() {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     function transferOwnership(address newOwner) public onlyOwner {
29         require(newOwner != address(0));
30         owner = newOwner;
31     }
32 }
33 
34 contract Pausable is Ownable {
35 
36     bool public paused = false;
37 
38     modifier whenNotPaused() {
39         require(!paused);
40         _;
41     }
42 
43     modifier whenPaused() {
44         require(paused);
45         _;
46     }
47 
48     function pause() public onlyOwner whenNotPaused {
49         paused = true;
50     }
51 
52     function unpause() public onlyOwner whenPaused {
53         paused = false;
54     }
55 }
56 
57 contract OTC is Pausable {
58 
59     struct Swap {
60         uint256 expires;
61         uint256 amountGive;
62         uint256 amountGet;
63         address tokenGet;
64         address tokenGive;
65         address buyer;
66         address seller;
67     }
68 
69     Swap[] public swaps;
70 
71     event SwapCreated(address indexed creator, uint256 swap);
72     event Swapped(address indexed seller, uint256 swap);
73 
74     function () public payable { revert(); }
75 
76     function createSwap(uint256 amountGive, uint256 amountGet, address tokenGive, address tokenGet, address seller) external whenNotPaused {
77         Swap memory swap = Swap({
78             expires: now + 1 days,
79             amountGive: amountGive,
80             amountGet: amountGet,
81             tokenGet: tokenGet,
82             tokenGive: tokenGive,
83             buyer: msg.sender,
84             seller: seller
85         });
86 
87         uint256 id = swaps.length;
88         swaps.push(swap);
89         SwapCreated(msg.sender, id);
90     }
91 
92     function cancelSwap(uint256 id) external whenNotPaused {
93         require(msg.sender == swaps[id].buyer);
94         delete swaps[id];
95     }
96 
97     function swap(uint256 id) external whenNotPaused {
98         Swap storage swap = swaps[id];
99 
100         require(swap.expires >= now);
101         require(canSwap(id, msg.sender));
102         require(ERC20(swap.tokenGive).transferFrom(swap.buyer, msg.sender, swap.amountGive));
103         require(ERC20(swap.tokenGet).transferFrom(msg.sender, swap.buyer, swap.amountGet));
104 
105         delete swaps[id];
106 
107         Swapped(msg.sender, id);
108     }
109 
110     function canSwap(uint256 id, address seller) public constant returns (bool) {
111         Swap storage swap = swaps[id];
112 
113         if (swap.seller != 0x0 && seller != swap.seller) {
114             return false;
115         }
116 
117         return swap.buyer != seller;
118     }
119 
120     function swapsFor(address _owner) public constant returns (uint[]) {
121         uint[] memory swapsForOwner;
122 
123         for (uint256 i = 0; i < swaps.length; i++) {
124             if (swaps[i].buyer == _owner) {
125                 swapsForOwner[swapsForOwner.length] = i;
126             }
127         }
128 
129         return swapsForOwner;
130     }
131 }