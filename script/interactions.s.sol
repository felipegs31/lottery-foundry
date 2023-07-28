// SPDX-License-Identifier: MIT

import {Script, console} from "forge-std/Script.sol";
import {Raffle} from "./../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

pragma solidity ^0.8.19;

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (, , address vrfCoordinator, , , ) = helperConfig.activeNetworkConfig();
        return createSubscription(vrfCoordinator);
    }

    function createSubscription(
        address vrfCoordinator
    ) public returns (uint64) {
        console.log("creating subscription on", block.chainid);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinator)
            .createSubscription();
        vm.stopBroadcast();

        console.log("subId", subId);

        return subId;
    }

    function run() external returns (uint64) {
        return createSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script {
    uint96 public constant FUND_AMOUNT = 3 ether;


    function fundSubscriptionUsingConfig() public payable returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (, , address vrfCoordinator, , uint64 subscriptionId, ) = helperConfig.activeNetworkConfig();
        return fundSubscription(vrfCoordinator);
    }

    function fundSubscription(
        address vrfCoordinator
    ) public payable returns (uint64) {
        console.log("funding subscription on", block.chainid);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinator).fundSubscription{
            value: msg.value
        }();
        vm.stopBroadcast();

        console.log("subId", subId);

        return subId;
    }

    function run() external payable returns (uint64) {
        return fundSubscriptionUsingConfig();
    }
}
