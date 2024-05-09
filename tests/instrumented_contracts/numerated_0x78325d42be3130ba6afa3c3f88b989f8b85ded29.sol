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
33 // 账本记录合约
34 // ----------------------------------------------------------------------------
35 contract IMCLedgerRecord is Owned{
36 
37     // 账本记录添加日志
38     event LedgerRecordAdd(uint _date, bytes32 _hash, uint _depth, string _fileFormat, uint _stripLen, bytes32 _balanceHash, uint _balanceDepth);
39 
40     // Token解锁统计记录
41     struct RecordInfo {
42         uint date;  // 记录日期（解锁ID）
43         bytes32 hash;  // 文件hash
44         uint depth; // 深度
45         string fileFormat; // 上链存证的文件格式
46         uint stripLen; // 上链存证的文件分区
47         bytes32 balanceHash;  // 余额文件hash
48         uint balanceDepth;  // 余额深度
49     }
50 
51     // 执行者地址
52     address public executorAddress;
53     
54     // 账本记录
55     mapping(uint => RecordInfo) public ledgerRecord;
56     
57     constructor() public{
58         // 初始化合约执行者
59         executorAddress = msg.sender;
60     }
61     
62     /**
63      * 修改executorAddress，只有owner能够修改
64      * @param _addr address 地址
65      */
66     function modifyExecutorAddr(address _addr) public onlyOwner {
67         executorAddress = _addr;
68     }
69     
70      
71     /**
72      * 账本记录添加
73      * @param _date uint 记录日期（解锁ID）
74      * @param _hash bytes32 文件hash
75      * @param _depth uint 深度
76      * @param _fileFormat string 上链存证的文件格式
77      * @param _stripLen uint 上链存证的文件分区
78      * @param _balanceHash bytes32 余额文件hash
79      * @param _balanceDepth uint 余额深度
80      * @return success 添加成功
81      */
82     function ledgerRecordAdd(uint _date, bytes32 _hash, uint _depth, string _fileFormat, uint _stripLen, bytes32 _balanceHash, uint _balanceDepth) public returns (bool) {
83         // 调用者需和Owner设置的执行者地址一致
84         require(msg.sender == executorAddress);
85         // 防止重复记录
86         require(ledgerRecord[_date].date != _date);
87 
88         // 记录解锁信息
89         ledgerRecord[_date] = RecordInfo(_date, _hash, _depth, _fileFormat, _stripLen, _balanceHash, _balanceDepth);
90 
91         // 解锁日志记录
92         emit LedgerRecordAdd(_date, _hash, _depth, _fileFormat, _stripLen, _balanceHash, _balanceDepth);
93         
94         return true;
95         
96     }
97 
98 }