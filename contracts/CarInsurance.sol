// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract CarInsurance {
    struct Policy {
        address policyHolder;
        uint256 premium;
        uint256 coverageAmount;
        bool isActive;
        uint256 startDate;
        uint256 endDate;
        uint256 kidDrivers;
        uint256 age;
        uint256 income;
        uint256 mvrPts;
    }

    struct Claim {
        uint256 claimAmount;
        uint256 claimDate;
        bool isProcessed;
        bool isApproved;
    }

    mapping(address => Policy) public policies;
    mapping(address => Claim[]) public claims;
    address public insurer;

    constructor() public {
        insurer = msg.sender;
    }

    modifier onlyInsurer() {
        require(msg.sender == insurer, "Only the insurer can perform this action");
        _;
    }

    function purchasePolicy(
        uint256 _premium,
        uint256 _coverageAmount,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _kidDrivers,
        uint256 _age,
        uint256 _income,
        uint256 _mvrPts
    ) public payable {
        require(msg.value == _premium, "Incorrect premium amount");

        policies[msg.sender] = Policy({
            policyHolder: msg.sender,
            premium: _premium,
            coverageAmount: _coverageAmount,
            isActive: true,
            startDate: _startDate,
            endDate: _endDate,
            kidDrivers: _kidDrivers,
            age: _age,
            income: _income,
            mvrPts: _mvrPts
        });
    }

    function submitClaim(
        uint256 _claimAmount,
        uint256 _claimDate,
        bool _isProcessed,
        bool _isApproved
    ) public {
        Policy storage policy = policies[msg.sender];
        require(policy.isActive, "No active policy found");
        require(block.timestamp <= policy.endDate, "Policy has expired");

        claims[msg.sender].push(Claim({
            claimAmount: _claimAmount,
            claimDate: _claimDate,
            isProcessed: _isProcessed,
            isApproved: _isApproved
        }));
    }

    function processClaim(address payable _policyHolder, uint256 _claimIndex) public onlyInsurer {
        Claim storage claim = claims[_policyHolder][_claimIndex];
        require(!claim.isProcessed, "Claim already processed");

        Policy storage policy = policies[_policyHolder];
        if (policy.kidDrivers < 2 && policy.age > 25 && policy.income > 50000 && policy.mvrPts < 3) {
            claim.isApproved = true;
            _policyHolder.transfer(claim.claimAmount);
        }
        
        claim.isProcessed = true;
    }

    function getPolicyDetails(address _policyHolder) public view returns (
        address policyHolder,
        uint256 premium,
        uint256 coverageAmount,
        bool isActive,
        uint256 startDate,
        uint256 endDate,
        uint256 kidDrivers,
        uint256 age,
        uint256 income,
        uint256 mvrPts
    ) {
        Policy memory policy = policies[_policyHolder];
        return (
            policy.policyHolder,
            policy.premium,
            policy.coverageAmount,
            policy.isActive,
            policy.startDate,
            policy.endDate,
            policy.kidDrivers,
            policy.age,
            policy.income,
            policy.mvrPts
        );
    }

    function getClaimDetails(address _policyHolder, uint256 _claimIndex) public view returns (
        uint256 claimAmount,
        uint256 claimDate,
        bool isProcessed,
        bool isApproved
    ) {
        Claim memory claim = claims[_policyHolder][_claimIndex];
        return (
            claim.claimAmount,
            claim.claimDate,
            claim.isProcessed,
            claim.isApproved
        );
    }
}