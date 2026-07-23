#include <bits/stdc++.h>
using namespace std;
#define int long long

enum class CarType {
    PRIVATE,
    TRUCK,
    BUS
};

string getCarTypeString(CarType type) {
    if (type == CarType::PRIVATE) return "PRIVATE";
    if (type == CarType::TRUCK) return "TRUCK";
    if (type == CarType::BUS) return "BUS";
}

class RadarInfo {
private:
    string plateNum;
    string date;
    CarType type;
    int speed;
    bool seatbelt;

public:
    RadarInfo(string p, string d, CarType c, int s, bool b) {
        plateNum = p;
        date = d;
        type = c;
        speed = s;
        seatbelt = b;
    }

    string getPlate() const { return plateNum; }
    string getDate() const { return date; }
    CarType getCarType() const { return type; }
    int getSpeed() const { return speed; }
    bool hasSeatbelt() const { return seatbelt; }

    void setPlate(string p) { plateNum = p; }
    void setDate(string d) { date = d; }
    void setCarType(CarType c) { type = c; }
    void setSpeed(int s) { speed = s; }
    void setSeatbelt(bool b) { seatbelt = b; }
};

class Rule {
public:
    virtual ~Rule() {}
    virtual string getName() = 0;
    virtual bool evaluate(const RadarInfo& obs, string& desc, int& fee) = 0;
};

class SpeedRule : public Rule {
private:
    CarType targetType;
    int maxSpeed;
    int fineAmount;

public:
    SpeedRule(CarType c, int maxS, int fee) {
        targetType = c;
        maxSpeed = maxS;
        fineAmount = fee;
    }

    string getName() override {
        return "Speed limit (" + getCarTypeString(targetType) + " <= " + to_string(maxSpeed) + ")";
    }

    bool evaluate(const RadarInfo& obs, string& desc, int& fee) override {
        if (obs.getCarType() == targetType && obs.getSpeed() > maxSpeed) {
            desc = "speed of " + to_string(obs.getSpeed()) + " exceeded max allowed " + to_string(maxSpeed);
            fee = fineAmount;
            return true;
        }
        return false;
    }
};

class SeatbeltRule : public Rule {
private:
    int fineAmount;

public:
    SeatbeltRule(int fee) {
        fineAmount = fee;
    }

    string getName() override {
        return "Seatbelt";
    }

    bool evaluate(const RadarInfo& obs, string& desc, int& fee) override {
        if (!obs.hasSeatbelt()) {
            desc = "Seatbelt not fastned";
            fee = fineAmount;
            return true;
        }
        return false;
    }
};

class Fine {
private:
    string plate;
    vector<pair<string, int>> violations;
    int total;

public:
    Fine(string p, vector<pair<string, int>> v) {
        plate = p;
        violations = v;
        total = 0;
        
        for (int i = 0; i < violations.size(); i++) {
            total += violations[i].second;
        }
    }

    int getTotal() { 
        return total; 
    }

    void print() {
        cout << "Traffic for car " << plate << "\n";
        cout << "Total amount: " << total << " EGP\n";
        cout << "Violations:\n";
        for (int i = 0; i < violations.size(); i++) {
            cout << "- " << violations[i].first << " : " << violations[i].second << " EGP\n";
        }
    }
};

class QuRadar {
private:
    vector<unique_ptr<Rule>> rules;
    map<string, int> totalFines;
    map<string, int> brokenRules;

public:
    void registerRule(unique_ptr<Rule> r) {
        rules.push_back(move(r));
    }

    void processObservation(const RadarInfo& obs) {
        vector<pair<string, int>> currentViolations;

        for (int i = 0; i < rules.size(); i++) {
            string desc = "";
            int fee = 0;
            
            if (rules[i]->evaluate(obs, desc, fee)) {
                currentViolations.push_back({desc, fee});
                brokenRules[rules[i]->getName()]++;
            }
        }

        if (currentViolations.empty()) {
            return;
        }

        Fine f(obs.getPlate(), currentViolations);
        f.print();
        totalFines[obs.getPlate()] += f.getTotal();
    }

    map<string, int> getAllPossibleFines() {
        return totalFines;
    }

    map<string, int> getAllViolatedRules() {
        return brokenRules;
    }
};

void solve() {
    
}

signed main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int t = 1;
    while (t--) {
        solve();
    }
    return 0;
}
