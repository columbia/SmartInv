1 pragma solidity ^ 0.4.11;
2 
3 
4 contract Dragon {
5     function transfer( address _to, uint256 _amount );
6 }
7 
8 
9 contract DragonDistributions {
10     
11 
12     address public dragon;
13     uint256 public clock;
14     mapping ( address => uint256 ) public  balanceOf;
15     mapping ( address => bool ) public  distributionOne;
16     mapping ( address => bool ) public  distributionTwo;
17     mapping ( address => bool ) public  distributionThree;
18     mapping ( address => bool ) public  advisors;
19    
20     
21     
22     
23     modifier onlyDragon() {
24         if (msg.sender != dragon) {
25             throw;
26         }
27         _;
28     }
29     
30     function DragonDistributions () {
31         
32         dragon = 0x1d1CF6cD3fE91fe4d1533BA3E0b7758DFb59aa1f;
33         clock = now;
34         
35         balanceOf[ 0xdFCf69C8FeD25F5150Db719BAd4EfAb64F628d31 ] = 45000000000000;
36         balanceOf[ 0x74Fc8fA4F99b6c19C250E4Fc6952051a95F6060D ] = 45000000000000;
37         balanceOf[ 0xCC3c6A89B5b8a054f21bCEff58B6429447cd8e5E ] = 45000000000000;
38         
39         advisors [ 0xdFCf69C8FeD25F5150Db719BAd4EfAb64F628d31 ] = true;
40         advisors [ 0x74Fc8fA4F99b6c19C250E4Fc6952051a95F6060D ] = true;
41         advisors [ 0xCC3c6A89B5b8a054f21bCEff58B6429447cd8e5E ] = true;
42         
43         
44         
45     }
46 
47 
48 
49     function withdrawDragons()
50     {
51         uint256 total = 0;
52         
53         require ( advisors[msg.sender] == true );
54         
55         Dragon drg = Dragon ( dragon );
56         
57         if ( distributionOne[ msg.sender ] == false ){
58             distributionOne[ msg.sender ] = true;
59             total += 15000000000000;
60             balanceOf[ msg.sender ] -= 15000000000000; 
61             
62         }
63         
64         if ( distributionTwo[ msg.sender ] == false && now > clock + 80 days ){
65             
66             
67             distributionTwo[ msg.sender ] = true;
68             total += 15000000000000;
69             balanceOf[ msg.sender ] -= 15000000000000; 
70             
71         }
72         
73         if ( distributionThree[ msg.sender ] == false && now > clock + 445 days ){
74             distributionThree[ msg.sender ] = true;
75             total += 15000000000000;
76             balanceOf[ msg.sender ] -= 15000000000000; 
77             
78         }
79         
80         
81         
82         
83         drg.transfer ( msg.sender, total);
84     } 
85  
86     
87     
88 }