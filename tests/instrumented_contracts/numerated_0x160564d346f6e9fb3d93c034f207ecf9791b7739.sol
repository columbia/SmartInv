1 pragma solidity ^0.4.7; 
2  
3 contract BaseAgriChainContract {
4     address creator; 
5     function BaseAgriChainContract() public    {   creator = msg.sender;   }
6     
7     modifier onlyBy(address _account)
8     {
9         if (msg.sender != _account)
10             throw;
11         _;
12     }
13     
14     function kill() onlyBy(creator)
15     {               suicide(creator);     }
16      
17      function setCreator(address _creator)  onlyBy(creator)
18     {           creator = _creator;     }
19   
20 }
21 contract AgriChainProductionContract   is BaseAgriChainContract    
22 {  
23     string  public  Organization;      //Production Organization
24     string  public  Product ;          //Product
25     string  public  Description ;      //Description
26     address public  AgriChainData;     //ProductionData
27     string  public  AgriChainSeal;     //SecuritySeal
28     string  public  Notes ;
29     
30     
31     function   AgriChainProductionContract() public
32     {
33         AgriChainData=address(this);
34     }
35     
36     function setOrganization(string _Organization)  onlyBy(creator)
37     {
38           Organization = _Organization;
39        
40     }
41     
42     function setProduct(string _Product)  onlyBy(creator)
43     {
44           Product = _Product;
45         
46     }
47     
48     function setDescription(string _Description)  onlyBy(creator)
49     {
50           Description = _Description;
51         
52     }
53     function setAgriChainData(address _AgriChainData)  onlyBy(creator)
54     {
55          AgriChainData = _AgriChainData;
56          
57     }
58     
59     
60     function setAgriChainSeal(string _AgriChainSeal)  onlyBy(creator)
61     {
62          AgriChainSeal = _AgriChainSeal;
63          
64     }
65     
66     
67      
68     function setNotes(string _Notes)  onlyBy(creator)
69     {
70          Notes =  _Notes;
71          
72     }
73 }