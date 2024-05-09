1 pragma solidity ^0.4.24;
2 
3 /**
4 
5 https://fortisgames.com https://fortisgames.com https://fortisgames.com https://fortisgames.com https://fortisgames.com
6 
7                                                                                                         
8 FFFFFFFFFFFFFFFFFFFFFF                                           tttt            iiii                   
9 F::::::::::::::::::::F                                        ttt:::t           i::::i                  
10 F::::::::::::::::::::F                                        t:::::t            iiii                   
11 FF::::::FFFFFFFFF::::F                                        t:::::t                                   
12   F:::::F       FFFFFFooooooooooo   rrrrr   rrrrrrrrr   ttttttt:::::ttttttt    iiiiiii     ssssssssss   
13   F:::::F           oo:::::::::::oo r::::rrr:::::::::r  t:::::::::::::::::t    i:::::i   ss::::::::::s  
14   F::::::FFFFFFFFFFo:::::::::::::::or:::::::::::::::::r t:::::::::::::::::t     i::::i ss:::::::::::::s 
15   F:::::::::::::::Fo:::::ooooo:::::orr::::::rrrrr::::::rtttttt:::::::tttttt     i::::i s::::::ssss:::::s
16   F:::::::::::::::Fo::::o     o::::o r:::::r     r:::::r      t:::::t           i::::i  s:::::s  ssssss 
17   F::::::FFFFFFFFFFo::::o     o::::o r:::::r     rrrrrrr      t:::::t           i::::i    s::::::s      
18   F:::::F          o::::o     o::::o r:::::r                  t:::::t           i::::i       s::::::s   
19   F:::::F          o::::o     o::::o r:::::r                  t:::::t    tttttt i::::i ssssss   s:::::s 
20 FF:::::::FF        o:::::ooooo:::::o r:::::r                  t::::::tttt:::::ti::::::is:::::ssss::::::s
21 F::::::::FF        o:::::::::::::::o r:::::r                  tt::::::::::::::ti::::::is::::::::::::::s 
22 F::::::::FF         oo:::::::::::oo  r:::::r                    tt:::::::::::tti::::::i s:::::::::::ss  
23 FFFFFFFFFFF           ooooooooooo    rrrrrrr                      ttttttttttt  iiiiiiii  sssssssssss    
24                                                                                                         
25 Discord:   https://discord.gg/gDtTX62
26 
27 
28 /** Proxy contract to buy tokens on Zethr,
29  *  because we forgot to add the onTokenBuy event to Zethr.
30  *  So we're proxying Zethr buys through this contract so that our website
31  *  can properly track and display Zethr token buys.
32 **/
33 contract ZethrProxy {
34     ZethrInterface zethr = ZethrInterface(address(0x573e869cA9355299cDdb3a912D444F137ded397c));
35     address owner = msg.sender;
36     
37     event onTokenPurchase(
38         address indexed customerAddress,
39         uint incomingEthereum,
40         uint tokensMinted,
41         address indexed referredBy
42     );
43     
44     function buyTokensWithProperEvent(address _referredBy, uint8 divChoice) public payable {
45         // Query token balance before & after to see how much we bought
46         uint balanceBefore = zethr.balanceOf(msg.sender);
47         
48         // Buy tokens with selected div rate
49         zethr.buyAndTransfer.value(msg.value)(_referredBy, msg.sender, "", divChoice);
50         
51         // Query balance after
52         uint balanceAfter = zethr.balanceOf(msg.sender);
53         
54         emit onTokenPurchase(
55             msg.sender,
56             msg.value,
57             balanceAfter - balanceBefore,
58             _referredBy
59         );
60     }
61     
62     function () public payable {
63         
64     }
65     
66     // Yes there are tiny amounts of divs generated on buy,
67     // but not enough to justify transferring to msg.sender - gas price makes it not worth it.
68     function withdrawMicroDivs() public {
69         require(msg.sender == owner);
70         owner.transfer(address(this).balance);
71     }
72 }
73 
74 contract ZethrInterface {
75     function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice) public payable;
76     function balanceOf(address _owner) view public returns(uint);
77 }