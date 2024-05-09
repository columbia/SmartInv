1 pragma solidity ^0.5.2;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 // ----------------------------------------------------------------------------
33 // 奖池记录合约
34 // ----------------------------------------------------------------------------
35 contract IMCPool is Owned{
36 
37     // 奖池记录添加日志
38     event PoolRecordAdd(bytes32 _chainId, bytes32 _hash, uint _depth, string _data, string _fileFormat, uint _stripLen);
39 
40     // Token奖池统计记录
41     struct RecordInfo {
42         bytes32 chainId; // 上链ID
43         bytes32 hash; // hash值
44         uint depth; // 层级
45         string data; // 竞价数据
46         string fileFormat; // 上链存证的文件格式
47         uint stripLen; // 上链存证的文件分区
48     }
49 
50     // 执行者地址
51     address public executorAddress;
52     
53     // 奖此记录
54     mapping(bytes32 => RecordInfo) public poolRecord;
55     
56     constructor() public{
57         // 初始化合约执行者
58         executorAddress = msg.sender;
59     }
60     
61     /**
62      * 修改executorAddress，只有owner能够修改
63      * @param _addr address 地址
64      */
65     function modifyExecutorAddr(address _addr) public onlyOwner {
66         executorAddress = _addr;
67     }
68     
69      
70     /**
71      * 奖池记录添加
72      * @param _chainId bytes32 上链ID
73      * @param _hash bytes32 hash值
74      * @param _depth uint 上链阶段:1 加密上链，2结果上链
75      * @param _data string 竞价数据
76      * @param _fileFormat string 上链存证的文件格式
77      * @param _stripLen uint 上链存证的文件分区
78      * @return success 添加成功
79      */
80     function poolRecordAdd(bytes32 _chainId, bytes32 _hash, uint _depth, string memory _data, string memory _fileFormat, uint _stripLen) public returns (bool) {
81         // 调用者需和Owner设置的执行者地址一致
82         require(msg.sender == executorAddress);
83         // 防止重复记录
84         require(poolRecord[_chainId].chainId != _chainId);
85 
86         // 记录解锁信息
87         poolRecord[_chainId] = RecordInfo(_chainId, _hash, _depth, _data, _fileFormat, _stripLen);
88 
89         // 解锁日志记录
90         emit PoolRecordAdd(_chainId, _hash, _depth, _data, _fileFormat, _stripLen);
91         
92         return true;
93         
94     }
95 
96 }