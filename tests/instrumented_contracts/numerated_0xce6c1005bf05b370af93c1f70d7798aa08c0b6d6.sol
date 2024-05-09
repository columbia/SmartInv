1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract VeRegistry is Ownable {
41 
42     //--- Definitions
43 
44     struct Asset {
45         address addr;
46         string meta;
47     }
48 
49     //--- Storage
50 
51     mapping (string => Asset) assets;
52 
53     //--- Events
54 
55     event AssetCreated(
56         address indexed addr
57     );
58 
59     event AssetRegistered(
60         address indexed addr,
61         string symbol,
62         string name,
63         string description,
64         uint256 decimals
65     );
66 
67     event MetaUpdated(string symbol, string meta);
68 
69     //--- Public mutable functions
70 
71     function register(
72         address addr,
73         string symbol,
74         string name,
75         string description,
76         uint256 decimals,
77         string meta
78     )
79         public
80         onlyOwner
81     {
82         assets[symbol].addr = addr;
83 
84         AssetRegistered(
85             addr,
86             symbol,
87             name,
88             description,
89             decimals
90         );
91 
92         updateMeta(symbol, meta);
93     }
94 
95     function updateMeta(string symbol, string meta) public onlyOwner {
96         assets[symbol].meta = meta;
97 
98         MetaUpdated(symbol, meta);
99     }
100 
101     function getAsset(string symbol) public constant returns (address addr, string meta) {
102         Asset storage asset = assets[symbol];
103         addr = asset.addr;
104         meta = asset.meta;
105     }
106 }
107 
108 contract VeTokenRegistry is VeRegistry {
109 }