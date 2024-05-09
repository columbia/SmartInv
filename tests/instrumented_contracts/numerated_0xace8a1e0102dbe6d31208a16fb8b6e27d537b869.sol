1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4     address public owner;
5     address public ownerCandidate;
6 
7     constructor() public {
8         owner = address(0x6b9E41bE828027Bf199b9bC4167A31566daB6B62); 
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15     
16     function changeOwner(address _newOwner) public onlyOwner {
17         ownerCandidate = _newOwner;
18     }
19     
20     function acceptOwnership() public {
21         require(msg.sender == ownerCandidate);  
22         owner = ownerCandidate;
23     }
24     
25 }
26 
27 contract AddressTree is Owned{
28     
29     // Max number of items in tree 
30     uint256 public constant TreeLim = 2;
31     
32     struct Tree{
33         mapping(uint256 => Tree) Items;
34         address Item;
35     }
36     
37     mapping(address => Tree) public TreeList; 
38     
39     function CheckTree(address root)
40         internal
41     {
42         Tree storage CurrentTree = TreeList[root];
43         if (CurrentTree.Item == address(0x0)){
44             // empty tree 
45             CurrentTree.Item = root;
46         }
47 
48     }
49     
50     constructor()
51         public
52     {
53     }
54     
55     
56     function AddItem(address root, address target)
57         public
58         onlyOwner
59     {
60         CheckTree(root);
61         CheckTree(target);
62         Tree storage CurrentTree = TreeList[root];
63         for (uint256 i=0; i<TreeLim; i++){
64             if (CurrentTree.Items[i].Item == address(0x0)){
65                 
66                 Tree storage TargetTree = TreeList[target];
67                 CurrentTree.Items[i] = TargetTree;
68                 return;
69             }
70         }
71         // no empty item found 
72         revert();
73     }
74     
75     function SetItem(address root, uint256 index, address target)
76         public    
77         onlyOwner
78     {
79         require(index < TreeLim);
80         CheckTree(root);
81         CheckTree(target);
82         Tree storage CurrentTree = TreeList[root];
83         Tree storage TargetTree = TreeList[target];
84         CurrentTree.Items[index] = TargetTree;
85         
86     }
87     
88     //web view item
89     function GetItems(address target)
90         view
91         public
92         returns (address[TreeLim])
93     {
94         address[TreeLim] memory toReturn;
95         Tree storage CurrentTree = TreeList[target];
96         for (uint256 i=0; i<TreeLim; i++){
97             toReturn[i] = CurrentTree.Items[i].Item;
98         }
99         return toReturn;
100     }
101     
102     
103 }