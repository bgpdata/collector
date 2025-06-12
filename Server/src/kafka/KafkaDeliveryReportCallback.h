/*
 * Copyright (c) 2013-2015 Cisco Systems, Inc. and others.  All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v1.0 which accompanies this distribution,
 * and is available at http://www.eclipse.org/legal/epl-v10.html
 *
 */

#ifndef COLLECTOR_KAFKADELIVERYREPORTCALLBACK_H
#define COLLECTOR_KAFKADELIVERYREPORTCALLBACK_H

#include <librdkafka/rdkafkacpp.h>
#include "Logger.h"

class KafkaDeliveryReportCallback : public RdKafka::DeliveryReportCb {
public:
    void dr_cb (RdKafka::Message &message);
};

#endif //COLLECTOR_KAFKADELIVERYREPORTCALLBACK_H
