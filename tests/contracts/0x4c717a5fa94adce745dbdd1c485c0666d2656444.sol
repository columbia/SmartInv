// File: contracts/InternalModule.sol

pragma solidity >=0.5.0 <0.6.0;

contract InternalModule {

    address[] _authAddress;

    address payable[] public _contractOwners = [
        address(0xD04C3c9eEC7BE36d28a925598B909954b4fd83cB)   // Prod
        // address(0x4ad16f3f6B4C1C48C644756979f96bcd0bfa077B)   // Truffle Develop
    ];

    address payable public _defaultReciver;

    constructor() public {

        require(_contractOwners.length > 0);

        _defaultReciver = _contractOwners[0];

        _contractOwners.push(msg.sender);
    }

    modifier OwnerOnly() {

        bool exist = false;
        for ( uint i = 0; i < _contractOwners.length; i++ ) {
            if ( _contractOwners[i] == msg.sender ) {
                exist = true;
                break;
            }
        }

        require(exist); _;
    }

    modifier DAODefense() {
        uint256 size;
        address payable safeAddr = msg.sender;
        assembly {size := extcodesize(safeAddr)}
        require( size == 0, "DAO_Warning" );
        _;
    }

    modifier APIMethod() {

        bool exist = false;

        for (uint i = 0; i < _authAddress.length; i++) {
            if ( _authAddress[i] == msg.sender ) {
                exist = true;
                break;
            }
        }

        require(exist); _;
    }

    function AuthAddresses() external view returns (address[] memory authAddr) {
        return _authAddress;
    }

    function AddAuthAddress(address _addr) external OwnerOnly {
        _authAddress.push(_addr);
    }

    function DelAuthAddress(address _addr) external OwnerOnly {

        for (uint i = 0; i < _authAddress.length; i++) {
            if (_authAddress[i] == _addr) {
                for (uint j = 0; j < _authAddress.length - 1; j++) {
                    _authAddress[j] = _authAddress[j+1];
                }
                delete _authAddress[_authAddress.length - 1];
                _authAddress.length--;
                return ;
            }
        }

    }
}

// File: contracts/interface/ERC20Interface.sol

interface ERC20Interface {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/interface/RecommendInterface.sol

interface RecommendInterface {


    function GetIntroducer( address _owner ) external view returns (address);


    function RecommendList( address _owner, uint256 depth ) external view returns ( address[] memory list, uint256 len );


    function ShortCodeToAddress( bytes6 shortCode ) external view returns (address);


    function AddressToShortCode( address _addr ) external view returns (bytes6);


    function TeamMemberTotal( address _addr ) external view returns (uint256);


    function IsValidMember( address _addr ) external view returns (bool);


    function IsValidMemberEx( address _addr ) external view returns (bool, uint256);


    function DirectValidMembersCount( address _addr ) external view returns (uint256);


    function RegisterShortCode( bytes6 shortCode ) external;


    function BindRelation(address _recommer ) external;


    function BindRelationEx(address _recommer, bytes6 shortCode ) external;


    function GetSearchDepthMaxLimit() external view returns (uint256);


    function API_MakeAddressToValid( address _owner ) external;
}

// File: contracts/library/RoundController.sol

library Times {
    function OneDay() public pure returns (uint256) {
        return 1 days;
    }
}

library TokenAssetPool {

    uint constant UINT_MAX = 2 ** 256 - 1;

    struct MainDB {

        mapping(address => uint256) totalAmountsMapping;

        mapping(address => uint256) assetsAmountMapping;
    }

    function TotalAmount(MainDB storage self, address owner) internal view returns (uint256) {
        return self.assetsAmountMapping[owner];
    }

    function TotalSum(MainDB storage self, address owner ) internal view returns (uint256) {
        return self.totalAmountsMapping[owner];
    }

    function AddAmount(MainDB storage self, address owner, uint256 amount) internal {

        require( amount <= UINT_MAX );

        self.assetsAmountMapping[owner] += amount;

        self.totalAmountsMapping[owner] += amount;
    }

    function SubAmount(MainDB storage self, address owner, uint256 amount) internal {

        require( amount <= UINT_MAX );
        require( TotalAmount(self,owner) >= amount );

        self.assetsAmountMapping[owner] -= amount;
    }

}

library StaticMath {

    function S(uint256 ir) internal pure returns (uint256 s) {

        s = 1000 ether;

        for (uint i = 0; i < ir; i ++ ) {
            s = s * 1300000 / 1000000;
        }

        /// INT
        s = s / 1 ether * 1 ether;
    }

    function P(uint256 ir) internal pure returns (uint256 r) {

        if ( ir >= 4 ) {

            for ( uint ji = 0; ji < ir - 3; ji++ ) {
                r += S(ji) * 300000 / 1000000;
            }

            for ( uint i = ir - 3; i < ir; i++ ) {
                r += S(i) * 80000 / 1000000;
            }

        } else if ( ir != 0 && ir < 4 ) {

            for ( uint i = 0; i < ir; i++ ) {
                r += S(i) * 80000 / 1000000;
            }

        } else {

            return 0;
        }

    }

    function O(uint256 ir, uint256 n) internal pure returns (uint256) {

        if (ir - n == 1 ) {
            return 400000;
        } else if (ir - n == 2 ) {
            return 350000;
        } else if (ir - n == 3 ) {
            return 250000;
        } else {
            return 0;
        }

    }

    function T(uint256 ir, uint256 n) internal pure returns (uint256) {
        return P(ir) * O(ir, n) / 1000000;
    }

    function W(uint256 ir, uint256 n) internal pure returns (uint256) {

        if ( ir - n <= 3 ) {

            uint256 subp = T(ir, n) * 1000000 / S(n);
            if ( subp != 0 ) {
                subp ++;
            }

            return 1000000 - subp;

        } else {

            return 1100000;
        }
    }

    function ProfitHandle(uint256 ir, bool irTimeoutable, uint256 n, uint256 ns) internal pure returns (uint256) {

        if ( (ir - n <= 3 && !irTimeoutable) || n > ir ) {
            return 0;
        }

        return ns * W(ir, n) / 1000000;
    }
}

library DynamicMath {

    struct MainDB {

        RecommendInterface RCMINC;

        uint[] dyp;
    }

    struct Request {
        address owner;
        uint oid;
        uint ownerDepositAmount;
        uint stProfix;
    }

    function Init( MainDB storage self, RecommendInterface rcminc ) internal {

        self.RCMINC = rcminc;

        self.dyp = [20, 15, 10, 10, 10, 5, 5, 5, 5, 5];
    }

    function ProfitHandle(
        MainDB storage self,
        RoundController.MainDB storage RCDB,
        Request memory req
    )
    internal view
    returns (
        uint256 len,
        address [] memory addrs,
        uint256 [] memory profixs
    ) {
        address parent = req.owner;
        len = self.dyp.length;
        addrs = new address[](len);
        profixs = new uint256[](len);

        for ( (uint i, uint j) = (0,0); i < self.RCMINC.GetSearchDepthMaxLimit() && j < self.dyp.length; i++ ) {

            parent = self.RCMINC.GetIntroducer(parent);

            if ( parent != address(0x0) && parent != address(0xFF) ) {


                uint s = self.RCMINC.DirectValidMembersCount(parent);
                if ( self.RCMINC.IsValidMember(parent) && ( s >= j+1 || s >= 6 ) ) {


                    addrs[j] = parent;
                    profixs[j] = req.stProfix * self.dyp[j] / 100;


                    if ( RCDB.roundList[req.oid].depositedMapping[parent].totalAmount * 2 < req.ownerDepositAmount ) {

                        uint bp = RCDB.roundList[req.oid].depositedMapping[parent].totalAmount * 200000 / req.ownerDepositAmount;

                        profixs[j] = profixs[j] * bp / 100000;
                    }

                    ++j;
                }

            } else {

                break;
            }
        }

    }

    function uint2str(uint i) internal pure returns (string memory c) {

        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;

        while (i != 0){
            bstr[k--] = byte( uint8(48 + i % 10) );
            i /= 10;
        }
        c = string(bstr);
    }

}

library LevelMath {

    struct MainDB {

        RecommendInterface RCMINC;

        uint256[] lvProfits;

        mapping(uint256 => mapping(address => uint256)) achievementMapping;

        uint256 searchDepth;
    }

    function Init( MainDB storage self, RecommendInterface _RINC ) internal {
        self.RCMINC = _RINC;
        self.lvProfits = [0, 10, 5, 5, 5, 5];
        self.searchDepth = 1024;
    }


    function SetSearchDepth( MainDB storage self, uint256 d) internal {
        self.searchDepth = d;
    }


    function AddAchievement( MainDB storage self, address owner, uint256 oid, uint256 amount) internal {


        address parent = owner;

        for ( uint i = 0; i < self.searchDepth; i++ ) {

            if ( parent != address(0x0) && parent != address(0xFF) ) {

                self.achievementMapping[oid][parent] += amount;

            } else {

                return ;
            }


            parent = self.RCMINC.GetIntroducer(parent);
        }
    }


    function ProfitHandle( MainDB storage self, address owner, uint256 oid, uint256 totalRoundCount, uint staticProfixAmount )
    internal view
    returns (
        uint256 len,
        address [] memory addrs,
        uint [] memory profitAmounts
    ) {
        len = self.lvProfits.length;
        addrs = new address[](len);
        profitAmounts = new uint[](len);


        address parent = owner;

        uint256[] memory copyProfits = self.lvProfits;

        for ( uint i = 0; i < self.searchDepth; i++ ) {

            parent = self.RCMINC.GetIntroducer(parent);

            if ( parent == address(0x0) || parent == address(0xFF) ) {
                break;
            }


            if ( !self.RCMINC.IsValidMember(parent) ) {
                continue;
            }


            uint parentLv = CurrentLevelOf(self, parent, oid, totalRoundCount);


            uint psum = 0;
            for ( uint p = 0; p <= parentLv; p++ ) {

                psum += copyProfits[p];


                copyProfits[p] = 0;
            }


            if ( psum > 0 ) {
                addrs[parentLv] = parent;
                profitAmounts[parentLv] = staticProfixAmount * psum / 100;
            }


            if ( parentLv >= self.lvProfits.length - 1 ) {
                break;
            }

        }
    }


    function CurrentLevelOf( MainDB storage self, address owner, uint256 oid, uint256 totalRoundCount )
    internal view
    returns (uint256) {


        (address [] memory communityList, uint256 rlen) = self.RCMINC.RecommendList(owner, 0);


        uint256 achievementSum = 0;
        uint256 maxCommunityAmount = 0;

        for ( uint i = 0; i < rlen; i++) {

            uint256 communitySum = 0;

            for ( uint o = oid; o < oid + 4 && o < totalRoundCount; o++ ) {
                communitySum += self.achievementMapping[o][communityList[i]];
            }

            achievementSum += communitySum;

            if ( communitySum > maxCommunityAmount ) {
                maxCommunityAmount = communitySum;
            }
        }

        achievementSum -= maxCommunityAmount;


        uint256 lv = 0;

        if ( achievementSum >= 100 ether ) {
            lv = 1;
        }

        if ( achievementSum >= 300 ether ) {
            lv = 2;
        }

        if ( achievementSum >= 1000 ether ) {
            lv = 3;
        }

        if ( achievementSum >= 3000 ether ) {
            lv = 4;
        }

        if ( achievementSum >= 9000 ether ) {
            lv = 5;
        }

        return lv;
    }

    function uint2str(uint i) internal pure returns (string memory c) {

        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;

        while (i != 0){
            bstr[k--] = byte( uint8(48 + i % 10) );
            i /= 10;
        }
        c = string(bstr);
    }

}

library LuckAssetPool {

    using TokenAssetPool for TokenAssetPool.MainDB;


    uint constant UINT_MAX = 2 ** 256 - 1;

    struct MainDB {


        uint256 currentRoundTempAmount;


        uint256 rewardAmountTotal;


        uint256 currentRID;


        mapping(uint256 => uint256) assetAmountMapping;


        mapping(uint256 => uint256) rollbackAmountMapping;


        mapping(uint256 => Invest[]) investMapping;
    }

    struct Invest {
        address who;
        uint256 when;
        uint256 amount;
    }

    function RoundTimeOutDelegate(MainDB storage self, uint256 timeoutable_oid, TokenAssetPool.MainDB storage userPool)
    internal
    returns (
        address[20] memory luckyOnes,
        uint256[20] memory rewardAmounts
    )
    {
        self.rollbackAmountMapping[timeoutable_oid] = self.currentRoundTempAmount;

        self.currentRoundTempAmount = 0;


        (luckyOnes, rewardAmounts) = winningThePrizeAtRID(self, self.currentRID, userPool);

        self.currentRID ++;
    }

    function RoundSuccessDelegate(MainDB storage self) internal {


        self.assetAmountMapping[self.currentRID] += self.currentRoundTempAmount;

        self.currentRoundTempAmount = 0;
    }


    function BalanceOfRID(MainDB storage self, uint256 rid) internal view returns (uint256) {
        return self.assetAmountMapping[rid];
    }

    function DoRollback(MainDB storage self, uint256 oid, uint256 amount) internal returns (uint256 realAmount) {

        if ( self.rollbackAmountMapping[oid] >= amount ) {

            self.rollbackAmountMapping[oid] -= amount;

            realAmount = amount;

        } else {

            realAmount = self.rollbackAmountMapping[oid];

            self.rollbackAmountMapping[oid] = 0;
        }

    }


    function AppendingAmount(MainDB storage self, uint256 amount) internal {
        self.assetAmountMapping[self.currentRID] += amount;
    }


    function AddAmountAndTryGetReward(MainDB storage self, address who, uint256 amount) internal returns (uint256 reward) {

        require( amount <= UINT_MAX );


        self.currentRoundTempAmount += (amount * 30000 / 1000000);

        self.investMapping[self.currentRID].push( Invest(who, now, amount) );


        reward = amount * 5 / 100;
        if ( self.rewardAmountTotal >= reward ) {

            self.rewardAmountTotal -= reward;

        } else {

            reward = self.rewardAmountTotal;
            self.rewardAmountTotal = 0;
        }
    }


    function SubAmount(MainDB storage self, uint256 rid, uint256 amount) internal {

        require( amount <= UINT_MAX );
        require( BalanceOfRID(self, rid) >= amount );

        self.assetAmountMapping[rid] -= amount;
    }


    function winningThePrizeAtRID(MainDB storage self, uint256 rid, TokenAssetPool.MainDB storage userPool )
    private
    returns (
        address[20] memory luckyOnes,
        uint256[20] memory rewardAmounts
    )
    {
        uint256 ridTotalAmount = self.assetAmountMapping[rid];
        uint256 ridTotalAmountDelta = ridTotalAmount;

        Invest[] storage _investList = self.investMapping[rid];


        if ( _investList.length == 0 ) {

            self.assetAmountMapping[rid] = 0;

            self.assetAmountMapping[rid+1] += ridTotalAmountDelta;

            return (luckyOnes, rewardAmounts);
        }


        uint8[20] memory rewardsDescProps = [
            50, /// desc 1
            10,10,10,10, /// desc 2 - 5
            5,5,5,5,5,5,5,5,5,5,5,5,5,5,5 /// desc 6-20
        ];


        uint256 descIndex = 0;

        for ( int li = int(_investList.length - 1); li >= 0 && descIndex < 20; li-- ) {

            Invest storage invest = _investList[uint(li)];


            bool exist = false;
            for ( uint exid = 0; exid < descIndex; exid ++ ) {

                if ( luckyOnes[exid] == invest.who ) {
                    exist = true;
                    break;
                }

            }


            if (exist) {
                continue;
            }


            uint256 rewardAmount = invest.amount * rewardsDescProps[descIndex];


            if ( descIndex == 0 && rewardAmount > ridTotalAmount * 10 / 100 ) { /// desc 1

                rewardAmount = ridTotalAmount * 10 / 100;

            } else if ( descIndex >= 1 && descIndex <= 4 && rewardAmount > ridTotalAmount * 5 / 100 ) { /// desc 2-5

                rewardAmount = ridTotalAmount * 5 / 100;

            } else if ( descIndex >= 5 && rewardAmount > ridTotalAmount * 2 / 100 ) {

                rewardAmount = ridTotalAmount * 2 / 100;
            }


            if ( rewardAmount < ridTotalAmountDelta ) {

                userPool.AddAmount( invest.who, rewardAmount );
                ridTotalAmountDelta -= rewardAmount;


                luckyOnes[descIndex] = invest.who;
                rewardAmounts[descIndex] = rewardAmount;
                ++descIndex;
            }

            else {

                userPool.AddAmount( invest.who, ridTotalAmountDelta );
                ridTotalAmountDelta = 0;

                luckyOnes[descIndex] = invest.who;
                rewardAmounts[descIndex] = ridTotalAmountDelta;

                break;
            }
        }


        if ( ridTotalAmountDelta > 0 ) {
            self.rewardAmountTotal += ridTotalAmountDelta;
        }


        self.assetAmountMapping[rid] = 0;
    }
}

library OwnerAssetPool {


    uint constant UINT_MAX = 2 ** 256 - 1;

    address constant OwnerAddress = address(0xD04C3c9eEC7BE36d28a925598B909954b4fd83cB);

    struct MainDB {

        ERC20Interface ERC20Inc;


        uint256 currentRoundTempAmount;
    }

    function Init(MainDB storage self, ERC20Interface _erc20inc) internal {
        self.ERC20Inc = _erc20inc;
    }

    function RoundTimeOutDelegate(MainDB storage self) internal {
        self.currentRoundTempAmount = 0;
    }

    function RoundSuccessDelegate(MainDB storage self) internal {

        self.ERC20Inc.transfer( OwnerAddress, self.currentRoundTempAmount );

        self.currentRoundTempAmount = 0;
    }


    function AddAmount(MainDB storage self, uint256 amount) internal {

        require( amount <= UINT_MAX );

        self.currentRoundTempAmount += (amount * 50000 / 1000000);
    }

}

library RoundController {

    using TokenAssetPool for TokenAssetPool.MainDB;
    using LevelMath for LevelMath.MainDB;
    using DynamicMath for DynamicMath.MainDB;
    using LuckAssetPool for LuckAssetPool.MainDB;
    using OwnerAssetPool for OwnerAssetPool.MainDB;

    struct Deposited {

        address owner;

        uint256 totalAmount;

        uint256 latestDepositedTime;

        bool autoReDepostied;

        uint256 toOID;

        uint256 totalStProfit;

        uint256 totalDyProfit;

        uint256 totalMrgProfit;
    }

    struct Round {

        uint256 rid;

        uint256 internalRoundID;

        uint8 status;

        uint256 totalAmount;

        uint256 currentAmount;

        uint256 createTime;

        uint256 startTime;

        uint256 endTime;

        mapping(address => Deposited) depositedMapping;
    }

    struct MainDB {


        uint256 newRIDInitProp;

        RecommendInterface RCMINC;
        ERC20Interface ERC20INC;

        LuckAssetPool.MainDB luckAssetPool;
        OwnerAssetPool.MainDB ownerAssetPool;
        TokenAssetPool.MainDB userTokenPool;

        Round[] roundList;


        mapping(uint256 => address[]) autoRedepositAddressMapping;
    }

    event LogsToken(
        address indexed owner,
        uint256 when,
        int256  amount,
        uint256 indexed oid,
        uint16 indexed typeID
    );

    event LogsAmount(
        address indexed owner,
        uint256 when,
        int256  amount,
        uint256 indexed oid,
        uint16 indexed typeID
    );

    function InitFristRound(
        MainDB storage self,
        uint256 atTime,
        RecommendInterface _rcminc,
        ERC20Interface _erc20inc

    ) internal returns (bool) {

        if ( self.roundList.length > 0 ) {
            return false;
        }

        self.newRIDInitProp = 10;

        self.RCMINC = _rcminc;

        self.ERC20INC = _erc20inc;

        self.ownerAssetPool.Init(_erc20inc);

        self.roundList.push(
            Round(
                0,///rid
                0,/// internalRoundID
                1,/// status
                1000 ether, /// totalAmount
                0, /// currentAmount
                atTime, /// createTime
                atTime + Times.OneDay() * 1, /// startTime
                atTime + Times.OneDay() * 8 /// endTime
            )
        );
    }

    function EnableAutoRedeposit(MainDB storage self, address owner, uint256 fromRoundIdx) internal returns (bool) {


        if ( !(self.roundList[fromRoundIdx].status == 2 || self.roundList[fromRoundIdx].status == 3) ) {
            return false;
        }


        Deposited storage ownerDepositedRecord = self.roundList[fromRoundIdx].depositedMapping[owner];


        address[] storage autoAddresses = self.autoRedepositAddressMapping[fromRoundIdx];


        if ( !ownerDepositedRecord.autoReDepostied ) {

            ownerDepositedRecord.autoReDepostied = true;
            autoAddresses.push(owner);

            return true;
        }

        return false;
    }

    function TotalCount(MainDB storage self) internal view returns (uint256) {
        return self.roundList.length;
    }

    function RoundAt(MainDB storage self, uint i) internal view returns (Round storage) {
        require( i >= 0 && i < self.roundList.length );
        return self.roundList[i];
    }

    function CurrentRound(MainDB storage self) internal view returns (Round storage r) {
        return self.roundList[self.roundList.length - 1];
    }

    function CurrentRountOID(MainDB storage self) internal view returns (uint256) {
        return self.roundList.length - 1;
    }

    function CurrentRoundIID(MainDB storage self) internal view returns (uint256) {
        return CurrentRound(self).internalRoundID;
    }

    function CurrentRoundRID(MainDB storage self) internal view returns (uint256) {
        return CurrentRound(self).rid;
    }

    function InternalRoundCount(MainDB storage self, uint256 oid) internal view returns (uint256) {

        uint256 iid = self.roundList[oid].internalRoundID;

        for ( uint i = oid + 1; i < self.roundList.length; i++ ) {
            if ( self.roundList[i].internalRoundID - iid == 1 ) {
                iid = self.roundList[i].internalRoundID;
            } else {
                break;
            }
        }

        return iid + 1;
    }

    function CurrentRoundStatus(MainDB storage self) internal view returns (uint8) {

        Round storage currRound = CurrentRound(self);

        if ( currRound.status == 1 ) {

            if ( now >= currRound.startTime && now < currRound.endTime ) {
                return 2;
            } else if ( now >= currRound.endTime ) {
                return 4;
            }
        }
        else if ( currRound.status == 2 ) {

            if ( now >= currRound.endTime ) {
                return 4;
            }

            if ( currRound.currentAmount >= currRound.totalAmount ) {
                return 3;
            }
        }

        return currRound.status;
    }

    function UpdateRoundStatus(MainDB storage self) internal {

        Round memory mRound = self.roundList[self.roundList.length - 1];
        Round storage sRound = self.roundList[self.roundList.length - 1];

        sRound.status = CurrentRoundStatus(self);

        if ( mRound.status == 2 && sRound.status == 3 ) {

            sRound.endTime = now;

            if ( sRound.internalRoundID >= 3 ) {
                self.roundList[ self.roundList.length - 1 - 3 ].status = 5;
            }

        }
        else if ( (mRound.status == 2 || mRound.status == 1) && sRound.status == 4 ) {

            uint256 internalRoundCount = InternalRoundCount( self, self.roundList.length - 1 );
            uint n = 0;
            if ( internalRoundCount > 4 ) {
                n = internalRoundCount - 4;
            }
            for ( uint i = n; i < self.roundList.length && i < n + 3; i++ ) {
                self.roundList[i].status = 6;
            }

        }

        CheckAndCreateNewRound(self);
    }

    function HasPriorityabPermission(MainDB storage self, address owner) internal view returns (bool) {

        if ( self.roundList[self.roundList.length - 1].internalRoundID != 0 ||
             self.roundList.length < 3 ) {
            return false;
        }

        for ( int i = int(self.roundList.length) - (1 + 2); i >= 0 && i > int(self.roundList.length) - (1 + 4); i-- ) {

            Round storage r = self.roundList[uint(i)];

            if ( r.status == 6 && r.depositedMapping[owner].totalAmount > 0 ) {
                return true;
            }

        }

        return false;
    }

    function DepositedToCurrentRound(MainDB storage self, address owner, uint256 amount, bool priorityab) internal returns (bool) {

        UpdateRoundStatus(self);

        Round storage currRound = CurrentRound(self);

        if ( currRound.currentAmount + amount > currRound.totalAmount ) {

            return false;

        } else if ( currRound.status != 2 && !priorityab ) {

            return false;
        }

        currRound.depositedMapping[owner].owner = owner;
        currRound.depositedMapping[owner].totalAmount += amount;
        currRound.depositedMapping[owner].latestDepositedTime = now;

        currRound.currentAmount += amount;

        self.ownerAssetPool.AddAmount( amount );

        uint256 reward = self.luckAssetPool.AddAmountAndTryGetReward( owner, amount );
        if ( reward > 0 ) {

            self.ERC20INC.transfer(owner, reward);

            emit LogsToken(owner, now, int256(reward), CurrentRountOID(self), 7);
        }

        UpdateRoundStatus(self);

        emit LogsToken(owner, now, -int256(amount), CurrentRountOID(self), 1);

        return true;
    }

    function SettlementRoundOf(
        MainDB storage self,
        DynamicMath.MainDB storage DyMath,
        LevelMath.MainDB storage LVMath,
        address owner,
        uint256 oid
    )
    internal
    returns (
        PESResponse memory rsp
    ) {
        UpdateRoundStatus(self);

        Round storage settRound = RoundAt(self, oid);

        Deposited storage depositedRecord = settRound.depositedMapping[owner];

        require( depositedRecord.totalStProfit == 0 );

        require( settRound.status == 4 || settRound.status == 5 || settRound.status == 6, "RoundStatusExpection");

        rsp = PreExecSettlementRoundOf(self, DyMath, LVMath, owner, oid );

        uint256 maxProfitLimitDelta = depositedRecord.totalAmount * 120000 / 1000000;

        depositedRecord.totalStProfit = rsp.originalAmount + rsp.staticProfix;

        for ( uint di = 0; di < rsp.dyLen; di++ ) {

            if ( rsp.dyAddrs[di] == address(0x0) || rsp.dyProfits[di] <= 0 ) {
                continue;
            }

            settRound.depositedMapping[rsp.dyAddrs[di]].totalDyProfit += rsp.dyProfits[di];

            if ( maxProfitLimitDelta < rsp.dyProfits[di] ) {
                maxProfitLimitDelta = 0;
            } else {
                maxProfitLimitDelta -= rsp.dyProfits[di];
            }

            if ( rsp.dyProfits[di] > 0 ) {

                self.userTokenPool.AddAmount(rsp.dyAddrs[di], rsp.dyProfits[di]);

                /// logs
                emit LogsAmount(rsp.dyAddrs[di], now, int256(rsp.dyProfits[di]), oid, uint16(200 + di));
            }
        }

        for ( uint mi = 0; mi < rsp.managerLen; mi++ ) {

            if ( rsp.managers[mi] == address(0x0) || rsp.managers[mi] == address(0xFF) || rsp.managerProfits[mi] == 0 ) {
                continue;
            }

            settRound.depositedMapping[rsp.managers[mi]].totalMrgProfit += rsp.managerProfits[mi];

            if ( maxProfitLimitDelta < rsp.managerProfits[mi] ) {
                maxProfitLimitDelta = 0;
            } else {
                maxProfitLimitDelta -= rsp.managerProfits[mi];
            }

            self.userTokenPool.AddAmount(rsp.managers[mi], rsp.managerProfits[mi]);

            /// logs
            emit LogsAmount(rsp.managers[mi], now, int256(rsp.managerProfits[mi]), oid, uint16(300 + mi));
        }

        if ( settRound.status == 5 ) {

            self.luckAssetPool.AppendingAmount( maxProfitLimitDelta );

            if ( !depositedRecord.autoReDepostied ) {

                self.ERC20INC.transfer(owner, depositedRecord.totalStProfit);

                /// logs
                emit LogsToken(owner, now, int(depositedRecord.totalStProfit), oid, 2);

            } else {

                Round storage targetRound = CurrentRound(self);

                if ((targetRound.status == 1 || targetRound.status == 2) &&
                    targetRound.totalAmount - targetRound.currentAmount >= depositedRecord.totalStProfit ) {

                    depositedRecord.toOID = self.roundList.length - 1;
                    DepositedToCurrentRound(self, owner, depositedRecord.totalStProfit, true);

                } else {

                    self.ERC20INC.transfer(owner, depositedRecord.totalStProfit);

                    depositedRecord.toOID = 1;

                    /// logs
                    emit LogsToken(owner, now, int(depositedRecord.totalStProfit), oid, 2);
                }
            }
        }
        else if ( settRound.status == 4 ) {

            uint256 rollbackLuckAmount = self.luckAssetPool.DoRollback( oid, depositedRecord.totalStProfit * 30000 / 1000000 );

            self.ERC20INC.transfer(owner, depositedRecord.totalStProfit * 970000 / 1000000 + rollbackLuckAmount );

            /// logs
            emit LogsToken(owner, now, int(depositedRecord.totalStProfit), oid, 5);

        }
        else if (settRound.status == 6 ) {

            self.ERC20INC.transfer(owner, depositedRecord.totalStProfit);

            /// logs
            emit LogsToken(owner, now, int(depositedRecord.totalStProfit), oid, 6);
        }

    }

    struct PESResponse {
        uint256 originalAmount;
        uint256 staticProfix;
        uint256 dyLen;
        address [] dyAddrs;
        uint256 [] dyProfits;
        uint256 managerLen;
        address [] managers;
        uint256 [] managerProfits;
    }
    function PreExecSettlementRoundOf(
        MainDB storage self,
        DynamicMath.MainDB storage DyMath,
        LevelMath.MainDB storage LVMath,
        address owner,
        uint256 oid
    )
    internal view
    returns (PESResponse memory rsp) {

        Round storage settRound = RoundAt(self, oid);
        // Round storage currRound = CurrentRound(self);

        uint internalCount = InternalRoundCount(self, oid);
        Round memory settMaxRound = self.roundList[ oid + (internalCount - settRound.internalRoundID - 1) ];

        rsp.originalAmount = settRound.depositedMapping[owner].totalAmount;

        // ProfitHandle(uint256 ir, bool irTimeoutable, uint256 n, uint256 ns) internal pure returns (uint256) {
        uint256 nowAmount = StaticMath.ProfitHandle(
            settMaxRound.internalRoundID,
            (settMaxRound.status == 4),
            settRound.internalRoundID,
            rsp.originalAmount
        );

        if ( nowAmount < rsp.originalAmount ) {
            rsp.originalAmount = nowAmount;
            return rsp;
        }

        rsp.staticProfix = nowAmount - rsp.originalAmount;

        ( rsp.dyLen, rsp.dyAddrs, rsp.dyProfits ) = DyMath.ProfitHandle(
            self,
            DynamicMath.Request(
                owner,
                oid,
                settRound.depositedMapping[owner].totalAmount,
                rsp.staticProfix
            )
        );

        (rsp.managerLen, rsp.managers, rsp.managerProfits) = LVMath.ProfitHandle( owner, oid, self.roundList.length, rsp.staticProfix );
    }

    function CheckAndCreateNewRound(MainDB storage self) internal {

        Round memory latestRound = self.roundList[self.roundList.length - 1];

        if ( latestRound.status == 3 ) {

            if ( latestRound.endTime - latestRound.createTime < 2 * Times.OneDay() ) {

                self.roundList.push(
                    Round(
                        latestRound.rid,
                        latestRound.internalRoundID + 1,
                        1, /// status
                        ((latestRound.totalAmount * 130) / 100) / 1 ether * 1 ether, /// totalAmount
                        0, /// currentAmount
                        latestRound.createTime + Times.OneDay() * 2, /// createTime
                        latestRound.createTime + Times.OneDay() * (2 + 1), /// startTime
                        latestRound.createTime + Times.OneDay() * (2 + 8) /// endTime
                    )
                );

            } else {

                self.roundList.push(
                    Round(
                        latestRound.rid, /// rid
                        latestRound.internalRoundID + 1, ///internalRoundID
                        1, /// status
                        ((latestRound.totalAmount * 130) / 100) / 1 ether * 1 ether, /// totalAmount
                        0, /// currentAmount
                        now, /// createTime
                        now + Times.OneDay() * 1, /// startTime
                        now + Times.OneDay() * 8 /// endTime
                    )
                );
            }

            self.luckAssetPool.RoundSuccessDelegate();
            self.ownerAssetPool.RoundSuccessDelegate();
        }
        else if ( latestRound.status == 4 ) {

            uint256 totalAmount = (latestRound.totalAmount - latestRound.currentAmount) * self.newRIDInitProp / 100;

            if ( totalAmount < 1000 ether ) {
                totalAmount = 1000 ether;
            }

            self.roundList.push(
                Round(
                    latestRound.rid + 1, /// rid
                    0, /// internalRoundID
                    1, /// status
                    totalAmount / 1 ether * 1 ether, /// totalAmount
                    0, /// currentAmount
                    now, /// createTime
                    now + Times.OneDay() * 1, /// startTime
                    now + Times.OneDay() * 8 /// endTime
                )
            );

            self.ownerAssetPool.RoundTimeOutDelegate();

            (address[20] memory addrs, uint256[20] memory amounts) = self.luckAssetPool.RoundTimeOutDelegate( self.roundList.length - 2, self.userTokenPool );

            for ( uint s = 0; s < 20; s++ ) {
                /// logs
                if ( addrs[s] != address(0x0) && addrs[s] != address(0xFF) ) {
                    emit LogsAmount( addrs[s], now, int(amounts[s]), self.roundList.length - 2, 100 );
                }
            }
        }
    }

    function PoolBalanceOf(MainDB storage self, address owner) internal view returns (uint256) {
        return self.userTokenPool.TotalAmount(owner);
    }

    function PoolWithdraw(MainDB storage self, address owner, uint256 amount) internal returns (bool) {

        if (self.userTokenPool.TotalAmount(owner) < amount ) {
            return false;
        }

        self.userTokenPool.SubAmount(owner, amount);

        self.ERC20INC.transfer(owner, amount - amount / 100);

        self.ERC20INC.transfer(address(0xdead), amount / 100);

        /// logs
        emit LogsAmount( owner, now, -int256(amount), 0, 6 );

        /// logs
        emit LogsToken( owner, now, int(amount), 0, 6 );

        return true;
    }

    function TotalDyAmountSum(MainDB storage self, address owner) internal view returns (uint256) {
        return self.userTokenPool.TotalSum(owner);
    }
}

// File: contracts/MainContract.sol
contract MainContract is InternalModule {

    RoundController.MainDB private _controller;
    using RoundController for RoundController.MainDB;

    DynamicMath.MainDB private _dyMath;
    using DynamicMath for DynamicMath.MainDB;

    LevelMath.MainDB private _levelMath;
    using LevelMath for LevelMath.MainDB;

    ERC20Interface public _Token;
    RecommendInterface public _RCMINC;

    uint256 public _depositMinLimit = 1 ether;


    uint256 public _depositMaxLimitProp = 1;

    constructor( RecommendInterface rinc, ERC20Interface tinc ) public {

        _RCMINC = rinc;
        _Token = tinc;

        _controller.InitFristRound(now, rinc, _Token);
        _dyMath.Init(rinc);
        _levelMath.Init(rinc);
    }

    function CurrentAllowance() public view returns (uint256) {
        return _Token.allowance(msg.sender, address(this));
    }


    function HasPriorityabPermission( address owner ) external view returns (bool) {
        return _controller.HasPriorityabPermission(owner);
    }


    function DoDeposit( uint256 amount ) external DAODefense {


        require( _RCMINC.GetIntroducer( msg.sender ) != address(0x0), "-0" );


        require( CurrentAllowance() >= amount, "-1" );


        require( amount % 0.001 ether == 0 );


        RoundController.Round storage currRound = _controller.CurrentRound();
        if ( currRound.totalAmount - currRound.currentAmount > 1 ether ) {
            require( amount >= _depositMinLimit, "Less then minlimit." );
        }


        require( amount <= currRound.totalAmount - currRound.currentAmount, "-2" );


        require( currRound.depositedMapping[msg.sender].totalAmount + amount <= currRound.totalAmount * _depositMaxLimitProp / 100, "-3" );


        require( _Token.transferFrom( msg.sender, address(this), amount ), "-4" );


        bool hasPriorityab = _controller.HasPriorityabPermission(msg.sender);


        require( _controller.DepositedToCurrentRound(msg.sender, amount, hasPriorityab), "-5" );


        _levelMath.AddAchievement(msg.sender, _controller.CurrentRountOID(), amount );


        if ( amount >= 10 ether ) {
            _RCMINC.API_MakeAddressToValid(msg.sender);
        }

    }


    function DoSettlement( uint256 oid )
    external DAODefense
    returns (
        uint256 originalAmount,
        uint256 staticProfix,
        address [] memory dyAddrs,
        uint256 [] memory dyProfits,
        address [] memory managers,
        uint256 [] memory managerProfits
    ) {

        RoundController.PESResponse memory rsp = _controller.SettlementRoundOf(
            _dyMath,
            _levelMath,
            msg.sender,
            oid
        );

        return (
            rsp.originalAmount,
            rsp.staticProfix,
            rsp.dyAddrs,
            rsp.dyProfits,
            rsp.managers,
            rsp.managerProfits
        );
    }

    function RoundTotalCount() external view returns (uint256) {
        return _controller.TotalCount();
    }

    function RoundStatusAt( uint256 oid ) external view returns (
        /// inside round id
        uint256 iid,

        uint8 status,

        uint256 totalAmount,

        uint256 currentAmount,

        uint256 createTime,

        uint256 startTime,

        uint256 endTime
    ) {
        uint256 id = oid;

        RoundController.Round memory round;

        if ( id >= _controller.TotalCount() ) {
            id = _controller.CurrentRountOID();
        }

        round = _controller.RoundAt(id);

        if ( id == _controller.CurrentRountOID() ) {
            status = _controller.CurrentRoundStatus();
        } else {
            status = round.status;
        }

        iid = round.internalRoundID;
        totalAmount = round.totalAmount;
        currentAmount = round.currentAmount;
        createTime = round.createTime;
        startTime = round.startTime;
        endTime = round.endTime;
    }

    function EnableAutoRedepostied( uint256 oid ) external {
        require( _controller.EnableAutoRedeposit( msg.sender, oid ) );
    }

    function DepositedRoundOIDS( address owner ) public view returns (uint256[] memory ids, uint256 len) {

        uint256[] memory tempIds = new uint256[](_controller.TotalCount());

        len = 0;

        for (uint i = 0; i < _controller.TotalCount(); i++ ) {
            if ( _controller.RoundAt(i).depositedMapping[owner].owner == owner ) {
                tempIds[len++] = i;
            }
        }

        if (len == 0) {
            return (new uint256[](0), 0);
        }

        ids = new uint256[](len);
        for ( uint256 si = 0; si < len; si++ ) {
            ids[si] = tempIds[si];
        }

    }

    function DepositedInfo( address owner, uint256 oid ) external view returns (

        uint256 statuse,

        uint256 totalAmount,

        uint256 latestDepositedTime,

        bool autoReDepostied,

        uint256 redepositedToOID,

        uint256 totalStProfit,

        uint256 totalDyProfit,

        uint256 totalMrgProfit,

        uint256 lv
    ) {
        require (oid < _controller.TotalCount() );

        RoundController.Round storage r = _controller.RoundAt(oid);
        RoundController.Deposited memory d = r.depositedMapping[owner];

        statuse = r.status;
        totalAmount = d.totalAmount;
        latestDepositedTime = d.latestDepositedTime;
        autoReDepostied = d.autoReDepostied;
        totalStProfit = d.totalStProfit;
        totalDyProfit = d.totalDyProfit;
        totalMrgProfit = d.totalMrgProfit;
        redepositedToOID = d.toOID;
        lv = _levelMath.CurrentLevelOf(owner, oid, _controller.TotalCount());
    }

    function CurrentDepositedTotalCount(address owner) external view returns (uint256 total) {

        (uint256[] memory allIDS, uint256 len) = DepositedRoundOIDS(owner);

        for ( uint i = 0; i < len; i++ ) {

            RoundController.Deposited memory d = _controller.RoundAt(allIDS[i]).depositedMapping[owner];

            if ( d.totalStProfit == 0 ) {
                total += d.totalAmount;
            }

        }
    }

    /// About LuckAsset Pool
    using LuckAssetPool for LuckAssetPool.MainDB;
    function BalanceOfLuckAssetPoolAtRID(uint256 rid) external view returns (uint256 ridTotal, uint256 rewardTotal) {

        uint i = rid;

        if ( rid > _controller.CurrentRoundRID() ) {
            i = _controller.CurrentRoundRID();
        }

        return (_controller.luckAssetPool.BalanceOfRID(i), _controller.luckAssetPool.rewardAmountTotal);
    }

    function PoolBalanceOf(address owner) external view returns (uint256) {
        return _controller.PoolBalanceOf(owner);
    }

    function PoolWithdraw(uint256 amount) external DAODefense {
        require( _controller.PoolWithdraw(msg.sender, amount) );
    }

    function TotalDyAmountSum(address owner) external view returns (uint256) {
        return _controller.TotalDyAmountSum(owner);
    }

    function Owner_SetDepositedMinLimit(uint256 a) external OwnerOnly {

        require(a > 0.001 ether);

        _depositMinLimit = a;
    }

    function Owner_SetDepositedMaxLimitProp(uint256 a) external OwnerOnly {

        require( a <= 100 );

        _depositMaxLimitProp = a;
    }

    function Owner_UpdateRoundStatus() external OwnerOnly {
        _controller.UpdateRoundStatus();
    }

    function Owner_SetNewRIDProp(uint256 p) external OwnerOnly {
        _controller.newRIDInitProp = p;
    }

    function Dev_QueryAchievement(address owner, uint256 oid) external view returns (uint256) {
        return _levelMath.achievementMapping[oid][owner];
    }

}