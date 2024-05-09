1 pragma solidity ^0.4.23;
2 
3 
4 contract PublicInterface { 
5     function getRabbitSirePrice(uint32 _bunny) public view returns(uint);
6     function setRabbitSirePrice( uint32 _bunny, uint count) external;
7 }
8 
9 contract SetSire {  
10     event ChengeSex(uint32 bunnyId, uint256 price);
11 
12     address public pubAddress; 
13 
14     PublicInterface publicContract; 
15  
16     constructor() public { 
17         transferContract(0x2Ed020b084F7a58Ce7AC5d86496dC4ef48413a24);
18     }
19     
20     function transferContract(address _pubAddress) public {
21         require(_pubAddress != address(0)); 
22         pubAddress = _pubAddress;
23         publicContract = PublicInterface(_pubAddress);
24     } 
25 
26 
27     function setRabbitSirePrice (
28         uint32 bunny_1, 
29         uint price_1,
30         uint32 bunny_2, 
31         uint price_2,
32         uint32 bunny_3, 
33         uint price_3,
34         uint32 bunny_4, 
35         uint price_4,
36         uint32 bunny_5, 
37         uint price_5,
38         uint32 bunny_6, 
39         uint price_6
40     ) public {
41 
42         if(publicContract.getRabbitSirePrice(bunny_1) == 0 && price_1 != 0){ 
43             publicContract.setRabbitSirePrice(bunny_1, price_1);
44           emit ChengeSex(bunny_1,  publicContract.getRabbitSirePrice(bunny_1));
45         }
46 
47         if(publicContract.getRabbitSirePrice(bunny_2) == 0 && price_2 != 0){ 
48             publicContract.setRabbitSirePrice(bunny_2, price_2);
49           emit ChengeSex(bunny_2,  publicContract.getRabbitSirePrice(bunny_2));
50         }
51 
52         if(publicContract.getRabbitSirePrice(bunny_3) == 0 && price_3 != 0){ 
53             publicContract.setRabbitSirePrice(bunny_3, price_3);
54           emit ChengeSex(bunny_3,  publicContract.getRabbitSirePrice(bunny_3));
55         }
56 
57         if(publicContract.getRabbitSirePrice(bunny_4) == 0 && price_4 != 0){ 
58             publicContract.setRabbitSirePrice(bunny_4, price_4);
59           emit ChengeSex(bunny_4,  publicContract.getRabbitSirePrice(bunny_4));
60         }
61 
62         if(publicContract.getRabbitSirePrice(bunny_5) == 0 && price_5 != 0){ 
63             publicContract.setRabbitSirePrice(bunny_5, price_5);
64           emit ChengeSex(bunny_5,  publicContract.getRabbitSirePrice(bunny_5));
65         }
66 
67         if(publicContract.getRabbitSirePrice(bunny_6) == 0 && price_6 != 0){ 
68             publicContract.setRabbitSirePrice(bunny_6, price_6);
69           emit ChengeSex(bunny_6,  publicContract.getRabbitSirePrice(bunny_6));
70         }
71     }
72 }