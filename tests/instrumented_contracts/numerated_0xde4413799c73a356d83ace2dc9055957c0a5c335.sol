1 /**+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
2                             abcLotto: a Block Chain Lottery
3 
4                             Don't trust anyone but the CODE!
5  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
6  /*
7  * This product is protected under license.  Any unauthorized copy, modification, or use without 
8  * express written consent from the creators is prohibited.
9  */
10 /*
11     address resolver for resolve contracts interract.
12     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
13     depoly on:
14     1) mainnet 
15         owner:      0x15ebb02F39563675Fd255d34b8c03650373A8F0F
16         address:    0xde4413799c73a356d83ace2dc9055957c0a5c335
17     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
18 */
19 pragma solidity ^0.4.20;
20 
21 contract abcResolver {
22     address owner;
23     address lotto;
24     address controller;
25     address wallet;
26     address inviterBook;
27     address[10] alternate;
28 
29     //modifier
30     modifier onlyOwner {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     constructor() public{
36         owner = msg.sender;
37     }
38 
39     function setNewOwner(address newOwner) public onlyOwner{
40         require(newOwner != address(0x0));
41         owner = newOwner;
42     }
43 
44     function getOwner() public view returns (address){
45         return owner;
46     }
47 
48     function getAddress() public view returns (address) {
49         return lotto;
50     }
51 
52     function setAddress(address newAddr) public onlyOwner{
53         require(newAddr != address(0x0));
54         lotto = newAddr;
55     }
56 
57     function getControllerAddress() public view returns (address) {
58         return controller;
59     }
60 
61     function setControllerAddress(address newAddr) public onlyOwner{
62         require(newAddr != address(0x0));
63         controller = newAddr;
64     }
65 
66     function getWalletAddress() public view returns (address) {
67         return wallet;
68     }
69 
70     function setWalletAddress(address newAddr) public onlyOwner{
71         require(newAddr != address(0x0));
72         wallet = newAddr;
73     }
74 
75     function getBookAddress() public view returns (address) {
76         return inviterBook;
77     }
78 
79     function setBookAddress(address newAddr) public onlyOwner{
80         require(newAddr != address(0x0));
81         inviterBook = newAddr;
82     }    
83 
84     function getAlternate(uint index) public view returns (address){
85         return alternate[index];
86     }
87 
88     function setAlternate(uint index, address newAddr) public onlyOwner{
89         require(index>=0 && index<10);
90         require(newAddr != address(0x0));
91         alternate[index] = newAddr;
92     }
93 }