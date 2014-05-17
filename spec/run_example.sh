irb='irb -f --inspect -I lib --prompt simple '
rm -f tmp/example.tmp
set -x
(
$irb > ,irb1.out <<EOF
require 'process_lock'
Process.pid
p = ProcessLock.new('tmp/example.tmp')
p.alive?
p.owner?
p.read
p.acquire!
p.alive?
p.owner?
p.read
sleep(10)
p.release!
p.alive?
p.owner?
p.read
EOF
) &

(
sleep 2
$irb <<EOF
require 'process_lock'
Process.pid
q = ProcessLock.new('tmp/example.tmp')
q.alive?
q.owner?
q.read
q.acquire!
q.alive?
q.owner?
q.read
EOF
) | tee ,irb2.out 

wait

exit
