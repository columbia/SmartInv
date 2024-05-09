1 pragma solidity ^0.4.24;
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
33 // 解锁记录合约
34 // ----------------------------------------------------------------------------
35 contract IMCUnlockRecord is Owned{
36 
37     // 解锁记录添加日志
38     event UnlockRecordAdd(uint _date, bytes32 _hash, string _data, string _fileFormat, uint _stripLen);
39 
40     // Token解锁统计记录
41     struct RecordInfo {
42         uint date;  // 记录日期（解锁ID）
43         bytes32 hash;  // 文件hash
44         string data; // 统计数据
45         string fileFormat; // 上链存证的文件格式
46         uint stripLen; // 上链存证的文件分区
47     }
48 
49     // 执行者地址
50     address public executorAddress;
51     
52     // 解锁记录
53     mapping(uint => RecordInfo) public unlockRecord;
54     
55     constructor() public{
56         // 初始化合约执行者
57         executorAddress = msg.sender;
58     }
59     
60     /**
61      * 修改executorAddress，只有owner能够修改
62      * @param _addr address 地址
63      */
64     function modifyExecutorAddr(address _addr) public onlyOwner {
65         executorAddress = _addr;
66     }
67     
68      
69     /**
70      * 解锁记录添加
71      * @param _date uint 记录日期（解锁ID）
72      * @param _hash bytes32 文件hash
73      * @param _data string 统计数据
74      * @param _fileFormat string 上链存证的文件格式
75      * @param _stripLen uint 上链存证的文件分区
76      * @return success 添加成功
77      */
78     function unlockRecordAdd(uint _date, bytes32 _hash, string _data, string _fileFormat, uint _stripLen) public returns (bool) {
79         // 调用者需和Owner设置的执行者地址一致
80         require(msg.sender == executorAddress);
81         // 防止重复记录
82         require(unlockRecord[_date].date != _date);
83 
84         // 记录解锁信息
85         unlockRecord[_date] = RecordInfo(_date, _hash, _data, _fileFormat, _stripLen);
86 
87         // 解锁日志记录
88         emit UnlockRecordAdd(_date, _hash, _data, _fileFormat, _stripLen);
89         
90         return true;
91         
92     }
93 
94 }