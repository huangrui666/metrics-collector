import sys
NAME="WITCHER3_LLM_DEFAULT_LLMPCORE"
PATH="/home/hr/metrics_collector/data/"
DATA=PATH+NAME

GPUMEM_FILE=DATA+'/'+NAME+"_gpumem"
second_avail_values = []
try:
    with open(GPUMEM_FILE, 'r') as file:
        avail_count = 0
        for line in file:
            if 'avail:' in line:
                avail_count += 1
                if avail_count % 3 == 2: # dGPU
                # if avail_count % 2 == 0: # iGPU
                    value = int(line.split('avail:')[1].strip()) /1024/1024/1024
                    second_avail_values.append(value)
    if second_avail_values:
        average = sum(second_avail_values) / len(second_avail_values)
        print("GPU availale memory Average: " + str(f"{average:.2f}") + " Max: " + str(max(second_avail_values)) + " Min: " + str(min(second_avail_values)))
    else:
        print("No 'avail:' values found.")
except FileNotFoundError:
    pass
except PermissionError:
    pass

GPUTOP_FILE=GPUMEM_FILE=DATA+'/'+NAME+"_gputop"
try:
    with open(GPUTOP_FILE, 'r') as file:
        lines = file.readlines()
    column_titles = lines[0].split()
    column_sums = {title: 0 for title in column_titles}
    column_counts = {title: 0 for title in column_titles}
    rcs_values = []
    for line in lines[2:]:
        values = line.split()
        for title, value in zip(column_titles, values):
            try:
                column_sums[title] += float(value)
                column_counts[title] += 1
                if 'RCS' in title:
                    rcs_values.append(float(value))
            except ValueError:
                pass
    for title in column_titles:
        if column_counts[title] > 0:
            average = column_sums[title] / column_counts[title]
            if 'RCS' in title:
                print("RCS Average: " + str(f"{average:.2f}") + " Max: " + str(max(rcs_values)) + " Min: " + str(min(rcs_values)))
            # else:
            #   print(f"{title} average: {average:.2f}")
            # else:
            #     print(f"{title} has no valid data for average calculation.")
except FileNotFoundError:
    pass
except PermissionError:
    pass

TOP_FILE=GPUMEM_FILE=DATA+'/'+NAME+"_top"
try:
    virt_sum = res_sum = cpu_sum = mem_sum = mem_total_sum = 0
    count = 0
    cpu_values = []
    mem_free=[]
    mem_usage = []
    res_values = []
    with open(TOP_FILE, 'r') as file:
        for line in file:
            if 'MiB Mem' in line:
                mem_total = float(line.split(':')[1].split(',')[1].strip('free').strip())
                mem_free.append(mem_total)
                mem_total_sum += mem_total
            if 'GameThread'in line or 'python' in line:
                parts = line.split()
                virt = float(parts[4][:-1])
                res = float(parts[5][:-1])
                res_values.append(res)
                cpu = float(parts[8])
                cpu_values.append(cpu)
                mem = float(parts[9])
                mem_usage.append(mem)
                virt_sum += virt
                res_sum += res
                cpu_sum += cpu
                mem_sum += mem
                count += 1

    if count > 0:
        virt_avg = virt_sum / count
        res_avg = res_sum / count
        cpu_avg = cpu_sum / count
        mem_avg = mem_sum / count
        mem_free_avg = mem_total_sum / count
        # print(f"VIRT average: {virt_avg}g")
        print("%CPU Average: " + str(f"{cpu_avg:.2f}") + " Max: " + str(max(cpu_values)) + " Min: " + str(min(cpu_values)))
        print("CPU RES Average: " + str(f"{res_avg:.2f}") + " Max: " + str(max(res_values)) + " Min: " + str(min(res_values)))
        # print("CPU %MEM Average: " + str(f"{mem_avg:.2f}") + " Max: " + str(max(mem_usage)) + " Min: " + str(min(mem_usage)))
        # print("CPU MiB free Mem Average: " + str(f"{mem_free_avg:.2f}") + " Max: " + str(max(mem_free)) + " Min: " + str(min(mem_free)))  
    else:
        print("No data found.")
except FileNotFoundError:
    pass
except PermissionError:
    pass

AI_FILE=DATA+'/'+NAME+"_AI"
try:
    with open(AI_FILE, 'r') as file:
        for line in file:
            if 'first_token_latency' in line or 'input_tokens_count' in line or 'after_token_latency' in line or 'output_tokens_count' in line or 'gpu_message' in line:
                print(line.strip())
except FileNotFoundError:
    pass
except PermissionError:
    pass
