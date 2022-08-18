#include "GDE.h"

class MyScene : public GDE::Scene {
        GDE::NinePatchSprite* ui{};

    public:
        explicit MyScene(GDE::Engine* _engine, const std::string& _debugName = "Editor") : Scene(_engine, _debugName) {

        }

        void onInit() override {

        }

        ~MyScene() {

        }
};

int main(int, char* []) {
    GDE::Engine _e;
    _e.onInit(new MyScene(&_e));
    _e.onRun();
    _e.destroy();
    return EXIT_SUCCESS;
}