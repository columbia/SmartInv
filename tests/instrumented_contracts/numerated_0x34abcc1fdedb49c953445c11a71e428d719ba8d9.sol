1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 ENS Trade Factory
6 ========================
7 
8 Listed names and additional information available at ensnames.com
9 Author: /u/Cintix
10 */
11 
12 // Interfaces for the various ENS contracts
13 contract AbstractENS {
14   function setResolver(bytes32 node, address resolver);
15 }
16 contract Resolver {
17   function setAddr(bytes32 node, address addr);
18 }
19 contract Deed {
20   address public previousOwner;
21 }
22 contract Registrar {
23   function transfer(bytes32 _hash, address newOwner);
24   function entries(bytes32 _hash) constant returns (uint, Deed, uint, uint, uint);
25 }
26 
27 // The child contract, used to make buying as simple as sending ETH.
28 contract SellENS {
29   SellENSFactory factory;
30   
31   function SellENS(){
32     // Store the address of the factory (0x34abcc1fdedb49c953445c11a71e428d719ba8d9)
33     factory = SellENSFactory(msg.sender);
34   }
35   
36   function () payable {
37     // Delegate the work back to the factory to save space on the blockchain.
38     // This saves on gas when creating sell contracts.
39     // Could be replaced with a delegatecall to a library, but that
40     // would require a second contract deployment and added complexity.
41     factory.transfer(msg.value);
42     factory.sell_label(msg.sender, msg.value);
43   }
44 }
45 
46 // The factory which produces the seller child contracts.
47 contract SellENSFactory {
48   // Store the relevant information for each child contract.
49   struct SellENSInfo {
50     string label;
51     uint price;
52     address owner;
53   }
54   mapping (address => SellENSInfo) public get_info;
55   
56   // The developer address, used for seller fees.
57   address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;
58   // The Ethereum Name Service primary contract.
59   AbstractENS ens = AbstractENS(0x314159265dD8dbb310642f98f50C066173C1259b);
60   // The Ethereum Name Service Registrar contract.
61   Registrar registrar = Registrar(0x6090A6e47849629b7245Dfa1Ca21D94cd15878Ef);
62   // The Ethereum Name Service Public Resolver contract.
63   Resolver resolver = Resolver(0x1da022710dF5002339274AaDEe8D58218e9D6AB5);
64   // The hash of ".eth" under which all top level names are registered.
65   bytes32 root_node = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
66   
67   // Events used to help track sales.
68   event SellENSCreated(SellENS sell_ens);
69   event LabelSold(SellENS sell_ens);
70   
71   // Called by name sellers to make a new seller child contract.
72   function createSellENS(string label, uint price) {
73     SellENS sell_ens = new SellENS();
74     // Store the seller's address so they can get paid when the name sells.
75     get_info[sell_ens] = SellENSInfo(label, price, msg.sender);
76     SellENSCreated(sell_ens);
77   }
78   
79   // Called only by seller child contracts when a name is purchased.
80   function sell_label(address buyer, uint amount_paid){
81     SellENS sell_ens = SellENS(msg.sender);
82     // Verify the sender is a child contract.
83     if (get_info[sell_ens].owner == 0x0) throw;
84     
85     string label = get_info[sell_ens].label;
86     uint price = get_info[sell_ens].price;
87     address owner = get_info[sell_ens].owner;
88     
89     // Calculate the hash of the name being bought.
90     bytes32 label_hash = sha3(label);
91     // Retrieve the name's deed.
92     Deed deed;
93     (,deed,,,) = registrar.entries(label_hash);
94     // Verify the deed's previous owner matches the seller.
95     if (deed.previousOwner() != owner) throw;
96     // Calculate the hash of the full name (i.e. rumours.eth).
97     bytes32 node = sha3(root_node, label_hash);
98     // Set the name's resolver to the public resolver.
99     ens.setResolver(node, resolver);
100     // Configure the resolver to direct payments sent to the name to the buyer.
101     resolver.setAddr(node, buyer);
102     // Transfer the name's deed to the buyer.
103     registrar.transfer(label_hash, buyer);
104 
105     // Dev fee of 5%
106     uint fee = price / 20;
107     // The seller pays nothing to unlist and get their name back.
108     if (buyer == owner) {
109       price = 0;
110       fee = 0;
111     }
112     // 5% to the dev
113     developer.transfer(fee);
114     // 95% to the seller
115     owner.transfer(price - fee);
116     // Any extra past the sale price is returned to the buyer.
117     if (amount_paid > price) {
118       buyer.transfer(amount_paid - price);
119     }
120     LabelSold(sell_ens);
121   }
122   
123   // The factory must be payable to receive funds from its child contracts.
124   function () payable {}
125 }