<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (c) 2008-2022, Hazelcast, Inc. All Rights Reserved.
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
  -->

<!--
  The default Hazelcast configuration.

  This XML file is used when no hazelcast.xml is present.

  To learn how to configure Hazelcast, please see the schema at
  https://hazelcast.com/schema/config/hazelcast-config-5.2.xsd
  or the Reference Manual at https://docs.hazelcast.com/
-->

<!--suppress XmlDefaultAttributeValue -->
<hazelcast xmlns="http://www.hazelcast.com/schema/config"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://www.hazelcast.com/schema/config
           http://www.hazelcast.com/schema/config/hazelcast-config-5.2.xsd">

    <!--
        The name of the cluster. All members of a single cluster must have the same cluster name
        configured and a client connecting to this cluster must use it as well.
    -->
    <cluster-name>conceptjs</cluster-name>

    <network>
        <!--
            The preferred port number where the Hazelcast instance will listen. The convention is
            to use 5701 and it is the default both here and in various tools connecting to
            Hazelcast. This configuration has the following attributes:
            - port-count:
                The default value is 100, meaning that Hazelcast will try to bind 100 ports.
                If you set the value of port as 5701, as members join the cluster, Hazelcast tries
                to find ports between 5701 and 5801. You can change the port count in cases like
                having large instances on a single machine or you are willing to have only a few
                ports assigned.
            - auto-increment:
                Default value is true. If port is set to 5701, Hazelcast will try to find free
                ports between 5701 and 5801. Normally, you will not need to change this value, but
                it comes in handy when needed. You may also want to choose to use only one port.
                In that case, you can disable the auto-increment feature of port by setting its
                value as false.
        -->
        <port auto-increment="true" port-count="100">5701</port>
        <outbound-ports>
            <!--
            Allowed port range when connecting to other nodes.
            0 or * means use system provided port.
            -->
            <ports>0</ports>
        </outbound-ports>

        <!--
            This configuration lets you choose a discovery mechanism that Hazelcast will use to
            form a cluster. Hazelcast can find members by multicast, TCP/IP lists and by various
            discovery mechanisms provided by different cloud APIs.
        -->
        <join>
            <!--
                Configuration for the Discovery Strategy Auto Detection. When it's enabled, it will
                walk through all available discovery strategies and detect the correct one for the
                current runtime environment.
            -->
            <auto-detection enabled="true"/>
            <!-- Enables/disables the multicast discovery mechanism. The default value is disabled. -->
            <multicast enabled="false">
                <!--
                    Specifies the multicast group IP address when you want to create clusters
                    within the same network. Its default value is 224.2.2.3.
                -->
                <multicast-group>224.2.2.3</multicast-group>
                <!--
                    Specifies the multicast socket port that the Hazelcast member listens to and
                    sends discovery messages through. Its default value is 54327.
                -->
                <multicast-port>54327</multicast-port>
            </multicast>

            <!-- Specifies whether the TCP/IP discovery is enabled or not. Default value is false. -->
            <tcp-ip enabled="false">
                <interface>127.0.0.1</interface>
                <member-list>
                    <member>${METRONOME_WEB_HOST_1}</member>
					<member>${METRONOME_WEB_HOST_2}</member>
                </member-list>
            </tcp-ip>
            <!--
                Specifies whether the member use the AWS API to get a list of candidate IPs to
                check. "access-key" and "secret-key" are needed to access the AWS APIs and the
                rest of the parameters work as filtering criteria that narrow down the list of
                IPs to check. Default value is false.
            -->
            <aws enabled="false">
            </aws>
            <!--
                Specifies whether the member use the GCP APIs to get a list of candidate IPs to
                check.
            -->
            <gcp enabled="false">
            </gcp>
            <!-- Specifies whether the member use the Azure REST API to get a list of candidate IPs to
                 check.
            -->
            <azure enabled="false">
            </azure>
            <!--
                Specifies whether the member use the Kubernetes APIs to get a list of candidate IPs to
                check.
            -->
			<kubernetes enabled="true">
			    <namespace>{{ .Release.Namespace }}</namespace>
				<service-name>metronome-discovery</service-name>
				<resolve-not-ready-addresses>true</resolve-not-ready-addresses>
		    </kubernetes>
            <!--
                Specifies whether the member use the Eureka Service Registry to get a list of candidate
                IPs to check.
            -->
            <eureka enabled="false">
                <!--
                    Defines if the Eureka Discovery SPI plugin will register itself with the Eureka 1
                    service discovery. It is optional. Default value is true.
                -->
                <self-registration>true</self-registration>
                <!--
                    Defines an eureka namespace to not collide with other service registry clients
                    in eureka-client.properties file. It is optional. Default value is hazelcast.
                -->
                <namespace>hazelcast</namespace>
            </eureka>
            <discovery-strategies>
            </discovery-strategies>
        </join>
        <!--
            Specifies which network interfaces Hazelcast should use. You need to set its "enabled"
            attribute to true to be able to use your defined interfaces. You can define multiple
            interfaces using its <interface> sub-element. By default, it is disabled.
        -->
        <interfaces enabled="false">
            <interface>10.10.1.*</interface>
        </interfaces>
        <!--
            Lets you configure SSL using the SSL context factory. This feature is available
            only in Hazelcast Enterprise. To be able to use it, encryption should NOT be enabled
            and you should first implement your SSLContextFactory class. Its configuration contains
            the factory class and SSL properties. By default, it is disabled.
        -->
        <ssl enabled="false"/>
        <!--
            Lets you add custom hooks to join and perform connection procedures (like a custom
            authentication negotiation protocol, etc.). This feature is available only in Hazelcast
            Enterprise. To be able to use it, you should first implement the MemberSocketInterceptor
            (for members joining to a cluster) or SocketInterceptor (for clients connecting to a
            member) class. Its configuration contains the class you implemented and socket
            interceptor properties. By default, it is disabled. The following is an example:
            <socket-interceptor enabled="true">
                <class-name>
                    com.hazelcast.examples.MySocketInterceptor
                </class-name>
                <properties>
                    <property name="property1">value1</property>
                    <property name="property2">value2</property>
                </properties>
            </socket-interceptor>
        -->
        <socket-interceptor enabled="false"/>
        <!--
            Lets you encrypt the entire socket level communication among all Hazelcast members.
            This feature is available only in Hazelcast Enterprise. Its configuration contains
            the encryption properties and the same configuration must be placed to all members.
            By default, it is disabled.
        -->
        <symmetric-encryption enabled="false">
            <!--
               encryption algorithm such as
               DES/ECB/PKCS5Padding,
               PBEWithMD5AndDES,
               AES/CBC/PKCS5Padding,
               Blowfish,
               DESede
            -->
            <algorithm>PBEWithMD5AndDES</algorithm>
            <!-- salt value to use when generating the secret key -->
            <salt>thesalt</salt>
            <!-- pass phrase to use when generating the secret key -->
            <password>thepass</password>
            <!-- iteration count to use when generating the secret key -->
            <iteration-count>19</iteration-count>
        </symmetric-encryption>
        <failure-detector>
            <icmp enabled="false"/>
        </failure-detector>
    </network>
    <partition-group enabled="false"/>
    <executor-service name="default">
        <!--Queue capacity. 0 means Integer.MAX_VALUE.-->
        <queue-capacity>0</queue-capacity>
        <pool-size>16</pool-size>
        <statistics-enabled>true</statistics-enabled>
    </executor-service>
    <durable-executor-service name="default">
        <capacity>100</capacity>
        <durability>1</durability>
        <pool-size>16</pool-size>
        <statistics-enabled>true</statistics-enabled>
    </durable-executor-service>
    <scheduled-executor-service name="default">
        <capacity>100</capacity>
        <durability>1</durability>
        <pool-size>16</pool-size>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
        <statistics-enabled>true</statistics-enabled>
    </scheduled-executor-service>
    <security>
        <client-block-unmapped-actions>true</client-block-unmapped-actions>
    </security>
    <queue name="default">
        <!--
            Maximum size of the queue. When a JVM's local queue size reaches the maximum,
            all put/offer operations will get blocked until the queue size
            of the JVM goes down below the maximum.
            Any integer between 0 and Integer.MAX_VALUE. 0 means
            Integer.MAX_VALUE. Default is 0.
        -->
        <max-size>0</max-size>
        <!--
            Number of backups. If 1 is set as the backup-count for example,
            then all entries of the map will be copied to another JVM for
            fail-safety. 0 means no backup.
        -->
        <backup-count>1</backup-count>

        <!--
            Number of async backups. 0 means no backup.
        -->
        <async-backup-count>0</async-backup-count>
        <!--
            Used to purge unused or empty queues. If you define a value (time in seconds)
            for this element, then your queue will be destroyed if it stays empty or
            unused for that time.
        -->
        <empty-queue-ttl>-1</empty-queue-ttl>

        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </queue>

    <!--
        Configuration for a device, which a tiered-store can reference and use for its disk-tier.
    -->
    <local-device name="default-tiered-store-device">
        <base-dir>tiered-store</base-dir>
        <capacity unit="GIGABYTES" value="256"/>
        <block-size>4096</block-size>
        <read-io-thread-count>4</read-io-thread-count>
        <write-io-thread-count>4</write-io-thread-count>
    </local-device>

    <map name="default">
        <!--
           Data type that will be used for storing recordMap.
           Possible values:
           BINARY (default): keys and values will be stored as binary data
           OBJECT : values will be stored in their object forms
           NATIVE : values will be stored in non-heap region of JVM
        -->
        <in-memory-format>BINARY</in-memory-format>

        <!--
            Metadata creation policy for this map. Hazelcast may process objects of supported types ahead of time to
            create additional metadata about them. This metadata then is used to make querying and indexing faster.
            Metadata creation may decrease put throughput.
            Valid values are:
            CREATE_ON_UPDATE (default): Objects of supported types are pre-processed when they are created and updated.
            OFF: No metadata is created.
        -->
        <metadata-policy>CREATE_ON_UPDATE</metadata-policy>

        <!--
            Number of backups. If 1 is set as the backup-count for example,
            then all entries of the map will be copied to another JVM for
            fail-safety. 0 means no backup.
        -->
        <backup-count>1</backup-count>
        <!--
            Number of async backups. 0 means no backup.
        -->
        <async-backup-count>0</async-backup-count>
        <!--
            Maximum number of seconds for each entry to stay in the map. Entries that are
            older than <time-to-live-seconds> and not updated for <time-to-live-seconds>
            will get automatically evicted from the map.
            Any integer between 0 and Integer.MAX_VALUE. 0 means infinite. Default is 0
        -->
        <time-to-live-seconds>0</time-to-live-seconds>
        <!--
            Maximum number of seconds for each entry to stay idle in the map. Entries that are
            idle(not touched) for more than <max-idle-seconds> will get
            automatically evicted from the map. Entry is touched if get, put or containsKey is called.
            Any integer between 0 and Integer.MAX_VALUE. 0 means infinite. Default is 0.
        -->
        <max-idle-seconds>0</max-idle-seconds>

        <eviction eviction-policy="NONE" max-size-policy="PER_NODE" size="0"/>
        <!--
            While recovering from split-brain (network partitioning),
            map entries in the small cluster will merge into the bigger cluster
            based on the policy set here. When an entry merge into the
            cluster, there might an existing entry with the same key already.
            Values of these entries might be different for that same key.
            Which value should be set for the key? Conflict is resolved by
            the policy set here. Default policy is PutIfAbsentMapMergePolicy

            There are built-in merge policies such as
            com.hazelcast.spi.merge.PassThroughMergePolicy; entry will be overwritten if merging entry exists for the key.
            com.hazelcast.spi.merge.PutIfAbsentMergePolicy ; entry will be added if the merging entry doesn't exist in the cluster.
            com.hazelcast.spi.merge.HigherHitsMergePolicy ; entry with the higher hits wins.
            com.hazelcast.spi.merge.LatestUpdateMergePolicy ; entry with the latest update wins.
        -->
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>

        <!--
           Control caching of de-serialized values. Caching makes query evaluation faster, but it cost memory.
           Possible Values:
                        NEVER: Never cache deserialized object
                        INDEX-ONLY: Caches values only when they are inserted into an index.
                        ALWAYS: Always cache deserialized values.
        -->
        <cache-deserialized-values>INDEX-ONLY</cache-deserialized-values>

        <!--
           Whether map level statistical information (total
           hits, memory-cost etc.) should be gathered and stored.
        -->
        <statistics-enabled>true</statistics-enabled>

        <!--
            Whether statistical information (hits, creation
            time, last access time etc.) should be gathered
            and stored. You have to enable this if you plan to
            implement a custom eviction policy, out-of-the-box
            eviction policies work regardless of this setting.
        -->
        <per-entry-stats-enabled>false</per-entry-stats-enabled>

        <!--
            Tiered Store configuration. By default, it is disabled.
        -->
        <tiered-store enabled="false">
            <memory-tier>
                <!--
                    The amount of memory to be reserved for the memory-tier of the tiered-store instance
                    of this map.
                -->
                <capacity unit="MEGABYTES" value="256"/>
            </memory-tier>

            <!--
                Whether disk-tier is enabled, and the name of the device to be used for the disk-tier
                of the tiered-store instance of this map.
            -->
            <disk-tier enabled="false" device-name="default-tiered-store-device"/>
        </tiered-store>

    </map>

    <multimap name="default">
        <backup-count>1</backup-count>
        <value-collection-type>SET</value-collection-type>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </multimap>

    <replicatedmap name="default">
        <in-memory-format>OBJECT</in-memory-format>
        <async-fillup>true</async-fillup>
        <statistics-enabled>true</statistics-enabled>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </replicatedmap>

    <list name="default">
        <backup-count>1</backup-count>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </list>

    <set name="default">
        <backup-count>1</backup-count>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </set>

    <reliable-topic name="default">
        <read-batch-size>10</read-batch-size>
        <topic-overload-policy>BLOCK</topic-overload-policy>
        <statistics-enabled>true</statistics-enabled>
    </reliable-topic>

    <ringbuffer name="default">
        <capacity>10000</capacity>
        <backup-count>1</backup-count>
        <async-backup-count>0</async-backup-count>
        <time-to-live-seconds>0</time-to-live-seconds>
        <in-memory-format>BINARY</in-memory-format>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </ringbuffer>
	
    <reliable-topic name="conceptUpdate">
        <read-batch-size>10</read-batch-size>
        <topic-overload-policy>DISCARD_OLDEST</topic-overload-policy>
        <statistics-enabled>true</statistics-enabled>
    </reliable-topic>
    
    <ringbuffer name="conceptUpdate">
        <capacity>10000</capacity>
        <backup-count>1</backup-count>
        <async-backup-count>0</async-backup-count>
        <time-to-live-seconds>0</time-to-live-seconds>
        <in-memory-format>BINARY</in-memory-format>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </ringbuffer>
    
    <reliable-topic name="conceptEvalUpdate">
        <read-batch-size>10</read-batch-size>
        <topic-overload-policy>DISCARD_OLDEST</topic-overload-policy>
        <statistics-enabled>true</statistics-enabled>
    </reliable-topic>
    
    <ringbuffer name="conceptEvalUpdate">
        <capacity>10000</capacity>
        <backup-count>1</backup-count>
        <async-backup-count>0</async-backup-count>
        <time-to-live-seconds>0</time-to-live-seconds>
        <in-memory-format>BINARY</in-memory-format>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </ringbuffer>

    <reliable-topic name="scheduleJobUpdate">
        <read-batch-size>10</read-batch-size>
        <topic-overload-policy>DISCARD_OLDEST</topic-overload-policy>
        <statistics-enabled>true</statistics-enabled>
    </reliable-topic>
    
    <ringbuffer name="scheduleJobUpdate">
        <capacity>10000</capacity>
        <backup-count>1</backup-count>
        <async-backup-count>0</async-backup-count>
        <time-to-live-seconds>0</time-to-live-seconds>
        <in-memory-format>BINARY</in-memory-format>
        <merge-policy batch-size="100">com.hazelcast.spi.merge.PutIfAbsentMergePolicy</merge-policy>
    </ringbuffer>

    <flake-id-generator name="default">
        <!--
            The number of IDs are pre-fetched on the background when one call to
            FlakeIdGenerator#newId() is made.
        -->
        <prefetch-count>100</prefetch-count>
        <!--
            The validity timeout in ms for how long the pre-fetched IDs can be used. If this
            time elapses, a new batch of IDs will be fetched. The generated IDs contain timestamp
            component, which ensures rough global ordering of IDs. If an ID is assigned to an
            object that was created much later, it will be much out of order. If you don't care
            about ordering, set this value to 0. This setting pertains only to newId() calls made
            on the member that configured it.
        -->
        <prefetch-validity-millis>600000</prefetch-validity-millis>
        <!--
            The offset for the timestamp component in milliseconds. The default value corresponds
            to the beginning of 2018, (1.1.2018 0:00 UTC). You can adjust the value to determine
            the lifespan of the generator.
        -->
        <epoch-start>1514764800000</epoch-start>
        <!--
            The offset that will be added to the node ID assigned to cluster member for this generator.
            Might be useful in A/B deployment scenarios where you have cluster A which you want to upgrade.
            You create cluster B and for some time both will generate IDs and you want to have them unique.
            In this case, configure node ID offset for generators on cluster B.
        -->
        <node-id-offset>0</node-id-offset>
        <!--
            The bit-length of the sequence component of this flake id generator. This configuration
            is limiting factor for the maximum rate at which IDs can be generated. Default is 6 bits.
        -->
        <bits-sequence>6</bits-sequence>
        <!-- The bit-length of node id component of this flake id generator. Default value is 16 bits. -->
        <bits-node-id>16</bits-node-id>
        <!--
            Sets how far to the future is the generator allowed to go to generate IDs without blocking,
            default is 15 seconds.
        -->
        <allowed-future-millis>15000</allowed-future-millis>
        <!-- Enables/disables statistics gathering for the flake-id generator on this member. -->
        <statistics-enabled>true</statistics-enabled>
    </flake-id-generator>

    <!--
        The version of the portable serialization. Portable version is used to differentiate two same
        classes that have changes on it like adding/removing field or changing a type of a field.
    -->
    <serialization>
        <portable-version>0</portable-version>
    </serialization>

    <!-- Enables a Hazelcast member to be a lite member -->
    <lite-member enabled="false"/>

    <cardinality-estimator name="default">
        <backup-count>1</backup-count>
        <async-backup-count>0</async-backup-count>
        <merge-policy batch-size="100">HyperLogLogMergePolicy</merge-policy>
    </cardinality-estimator>

    <crdt-replication>
        <replication-period-millis>1000</replication-period-millis>
        <max-concurrent-replication-targets>1</max-concurrent-replication-targets>
    </crdt-replication>

    <pn-counter name="default">
        <replica-count>2147483647</replica-count>
        <statistics-enabled>true</statistics-enabled>
    </pn-counter>

    <cp-subsystem>
        <cp-member-count>0</cp-member-count>
        <group-size>0</group-size>
        <session-time-to-live-seconds>300</session-time-to-live-seconds>
        <session-heartbeat-interval-seconds>5</session-heartbeat-interval-seconds>
        <missing-cp-member-auto-removal-seconds>14400</missing-cp-member-auto-removal-seconds>
        <fail-on-indeterminate-operation-state>false</fail-on-indeterminate-operation-state>
        <cp-member-priority>0</cp-member-priority>
        <raft-algorithm>
            <leader-election-timeout-in-millis>2000</leader-election-timeout-in-millis>
            <leader-heartbeat-period-in-millis>5000</leader-heartbeat-period-in-millis>
            <max-missed-leader-heartbeat-count>5</max-missed-leader-heartbeat-count>
            <append-request-max-entry-count>100</append-request-max-entry-count>
            <commit-index-advance-count-to-snapshot>10000</commit-index-advance-count-to-snapshot>
            <uncommitted-entry-count-to-reject-new-appends>100</uncommitted-entry-count-to-reject-new-appends>
            <append-request-backoff-timeout-in-millis>100</append-request-backoff-timeout-in-millis>
        </raft-algorithm>
    </cp-subsystem>

    <metrics enabled="true">
        <management-center enabled="true">
            <retention-seconds>5</retention-seconds>
        </management-center>
        <jmx enabled="true"/>
        <collection-frequency-seconds>5</collection-frequency-seconds>
    </metrics>

    <sql>
        <statement-timeout-millis>0</statement-timeout-millis>
    </sql>

    <jet enabled="false" resource-upload-enabled="false">
        <!-- time spacing of flow-control (ack) packets -->
        <flow-control-period>100</flow-control-period>
        <!-- number of backup copies to configure for Hazelcast IMaps used internally in a Jet job -->
        <backup-count>1</backup-count>
        <!-- the delay after which auto-scaled jobs will restart if a new member is added to the
             cluster. The default is 10 seconds. Has no effect on jobs with auto scaling disabled -->
        <scale-up-delay-millis>10000</scale-up-delay-millis>
        <!-- Sets whether Lossless Job Restart is enabled for the node. With
             Lossless Restart, Jet persists job snapshots to disk automatically
             and you can restart the whole cluster without losing the jobs and
             their state.

             This feature requires Hazelcast Enterprise and is implemented on top of the
             Persistence feature. Therefore you should enable and configure Persistence,
             especially the base directory where to store the recovery files.
         -->
        <lossless-restart-enabled>false</lossless-restart-enabled>
        <!-- Sets the maximum number of records that can be accumulated by any single
             Processor instance.
             Operations like grouping, sorting or joining require certain amount of
             records to be accumulated before they can proceed. You can set this option
             to reduce the probability of OutOfMemoryError.

             This option applies to each Processor instance separately, hence the
             effective limit of records accumulated by each cluster member is influenced
             by the vertex's localParallelism and the number of jobs in the cluster.

             Currently, maxProcessorAccumulatedRecords limits:
                - number of items sorted by the sort operation
                - number of distinct keys accumulated by aggregation operations
                - number of entries in the hash-join lookup tables
                - number of entries in stateful transforms
                - number of distinct items in distinct operation

             Note: the limit does not apply to streaming aggregations.
         -->
        <max-processor-accumulated-records>9223372036854775807</max-processor-accumulated-records>
        <edge-defaults>
            <!-- capacity of the concurrent SPSC queue between each two processors -->
            <queue-size>1024</queue-size>

            <!-- network packet size limit in bytes, only applies to distributed edges -->
            <packet-size-limit>16384</packet-size-limit>

            <!-- receive window size multiplier, only applies to distributed edges -->
            <receive-window-multiplier>3</receive-window-multiplier>
        </edge-defaults>
    </jet>
    <integrity-checker enabled="false"/>
</hazelcast>
